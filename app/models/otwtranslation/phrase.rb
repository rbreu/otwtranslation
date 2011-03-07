require 'digest/md5'
require 'date'

class Otwtranslation::Phrase < ActiveRecord::Base

  def self.find_or_create(label, description="")
    key = generate_key(label, description)
    phrase = find_by_key(key) || create(:key => key, 
                                        :label => label, 
                                        :description => description,
                                        :locale => OtwtranslationConfig.DEFAULT_LOCALE)

    # If the phrase hasn't been updated for PHRASE_UPDATE_INTERVAL,
    # touch it 
    t, unit = OtwtranslationConfig.PHRASE_UPDATE_INTERVAL.split
    if phrase.updated_at < t.to_i.send(unit).ago
      phrase.touch
    end
    
    return phrase
  end

  
  def self.generate_key(label, description="")
    Digest::MD5.hexdigest("#{label};;;#{description}")
  end

end
