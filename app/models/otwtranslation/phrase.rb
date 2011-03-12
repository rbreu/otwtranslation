require 'digest/md5'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  belongs_to :source, :class_name => "Otwtranslation::Source"

  after_destroy :remove_from_cache
  after_save :remove_from_cache

  def self.find_or_create(label, description="", source={})
    key, cache_key = generate_keys(label, description)

    phrase = Rails.cache.read(cache_key)
    
    return phrase if phrase && phrase.version == OtwtranslationConfig.VERSION

    phrase = find_by_key(key) || create(:key => key, 
                                        :label => label, 
                                        :description => description,
                                        :locale => OtwtranslationConfig.DEFAULT_LOCALE)

    phrase.version = OtwtranslationConfig.VERSION
    phrase.source = Otwtranslation::Source.find_or_create(source) 
    phrase.save
    Rails.cache.write(cache_key, phrase)
    return phrase.freeze
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
