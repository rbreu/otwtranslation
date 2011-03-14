require 'digest/md5'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  has_and_belongs_to_many(:sources, 
                          :join_table => :otwtranslation_phrases_sources)

  #after_destroy :remove_from_cache
  #after_save :remove_from_cache

  def self.find_or_create(label, description="", source={})
    key, cache_key = generate_keys(label, description)

    puts cache_key

    phrase = Rails.cache.read(cache_key)
    source = Otwtranslation::Source.find_or_create(source)

    if phrase
      puts phrase.sources
    else
      puts "nil nil nil"
    end
    
    if phrase && phrase.version == OtwtranslationConfig.VERSION && phrase.sources.exists?(source.id)
      puts "return"
      return phrase
    end

    phrase = find_by_key(key) || create(:key => key, 
                                        :label => label, 
                                        :description => description,
                                        :locale => OtwtranslationConfig.DEFAULT_LOCALE)

    phrase.version = OtwtranslationConfig.VERSION
    puts "1========="

    unless phrase.sources.exists?(source.id)
      phrase.sources << source
    end
    puts "2========="
    phrase.save
    phrase.freeze
    Rails.cache.write(cache_key, phrase)
    return phrase #.freeze
  end

  def cache_key
    "otwtranslation_phrase_#{key}"
  end

  def self.generate_keys(label, description="")
    md5 = Digest::MD5.hexdigest("#{label};;;#{description}")
    return md5, "otwtranslation_phrase_#{md5}"
  end

  
  def to_param
    key
  end

  def remove_from_cache
    Rails.cache.delete(cache_key)
  end


end
