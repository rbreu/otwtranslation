require 'digest/md5'
require 'date'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  
  def self.find_or_create(label, description="")
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
    return [md5, "otwtranslation_phrase_#{md5}"]
  end

  def to_param
    key
  end

end
