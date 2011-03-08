require 'digest/md5'
require 'date'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  
  def self.find_or_create(label, description="")
    key = generate_key(label, description)
    
    phrase = Rails.cache.read(key)
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
    Rails.cache.write(key, phrase, :expires_in => t.to_i.send(unit))
    return phrase.freeze
  end


  def is_expired?
    t, unit = OtwtranslationConfig.PHRASE_EXPIRY_INTERVAL.split
    return updated_at < t.to_i.send(unit).ago
  end
  
  
  def self.generate_key(label, description="")
    Digest::MD5.hexdigest("#{label};;;#{description}")
  end

end
