require 'digest/md5'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  has_and_belongs_to_many(:sources, :uniq => true,
                          :join_table => :otwtranslation_phrases_sources)
  before_destroy :remove_sources

  def self.find_or_create(label, description="", controller="", uri="")
    key, cache_key = generate_keys(label, description)

    phrase = Rails.cache.read(cache_key)
    return phrase if phrase

    phrase = find_by_key(key)
    if phrase
      phrase.touch
    else
      phrase = create(:key => key, 
                      :label => label, 
                      :description => description,
                      :locale => OtwtranslationConfig.DEFAULT_LOCALE)
    end

    phrase.add_source(controller, uri) unless controller == ""
    
    t, unit = OtwtranslationConfig.PHRASE_UPDATE_INTERVAL.split
    Rails.cache.write(cache_key, phrase,
                      :expires_in => t.to_i.send(unit))
    return phrase.freeze
  end


  def is_expired?
    t, unit = OtwtranslationConfig.PHRASE_EXPIRY_INTERVAL.split
    return updated_at < t.to_i.send(unit).ago
  end
  
  
  def self.generate_keys(label, description="")
    md5 = Digest::MD5.hexdigest("#{label};;;#{description}")
    return md5, "otwtranslation_phrase_#{md5}"
  end

  
  def to_param
    key
  end

  
  def add_source(controller, uri="")
    source = Otwtranslation::Source.find_or_create(controller, uri)
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
    # Efficiency? It's only small numbers, though
    sources.each do |s| 
      sources.delete(s)
      Otwtranslation::Source.destroy_if_orphaned(s)
    end
  end
  
end
