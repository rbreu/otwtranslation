require 'digest/md5'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  has_and_belongs_to_many(:sources, :uniq => true,
                          :join_table => :otwtranslation_phrases_sources)
  before_destroy :remove_sources

  def self.find_or_create(label, description="", source={})
    key, cache_key = generate_keys(label, description)

    phrase = Rails.cache.read(cache_key)
    
    return phrase if phrase && phrase.version == OtwtranslationConfig.VERSION

    phrase = find_by_key(key) || create(:key => key, 
                                        :label => label, 
                                        :description => description,
                                        :locale => OtwtranslationConfig.DEFAULT_LOCALE)

    phrase.version = OtwtranslationConfig.VERSION
    phrase.save
    #phrase.add_source(source[:controller], source[:action], source[:url]) 
    Rails.cache.write(cache_key, phrase)
    return phrase.freeze
  end


  def self.generate_keys(label, description="")
    md5 = Digest::MD5.hexdigest("#{label};;;#{description}")
    return md5, "otwtranslation_phrase_#{md5}"
  end

  
  def to_param
    key
  end

  
  def add_source(controller, action, url="")
    source = Otwtranslation::Source.find_or_create(controller, action, url)
    sources << source
    
    if sources.all.count > OtwtranslationConfig.MAX_SOURCES_PER_PHRASE.to_i
      remove_oldest_source
    end
  end

  
  def remove_oldest_source
    oldest = sources.order("created_at ASC").first
    sources.delete(oldest)
    Otwtranslation::Source.destroy_if_orphaned(oldest)
  end


  def remove_sources
    sources.each do |s| 
      sources.delete(s)
      Otwtranslation::Source.destroy_if_orphaned(s)
    end
  end
  
end
