require 'digest/md5'

class Otwtranslation::Phrase < ActiveRecord::Base

  def self.find_or_create(label, description="")
    key = generate_key(label, description)
    phrase = find_by_key(key) || create(:key => key, 
                                        :label => label, 
                                        :description => description,
                                        :locale => OtwtranslationConfig.DEFAULT_LOCALE)
    return phrase
  end

  
  def self.generate_key(label, description="")
    Digest::MD5.hexdigest("#{label};;;#{description}")
  end

end
