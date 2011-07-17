class Otwtranslation::Language < Language
  
  has_many(:translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'language_short', :primary_key => 'short')

  has_many(:approved_translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'language_short', :primary_key => 'short',
           :conditions => {:approved => true} )

  after_destroy :remove_from_cache
  after_save :add_to_cache

  def percentage_translated
    all = Otwtranslation::Phrase.count.to_f
    return 0 if all == 0
    translated = translations.select("DISTINCT(phrase_key)").count.to_f
    translated/all * 100
  end
    
  def percentage_approved
    all = Otwtranslation::Phrase.count.to_f
    return 0 if all == 0
    translated = approved_translations.select("DISTINCT(phrase_key)").count.to_f
    translated/all * 100
  end
    
  
  scope :visible, where(:translation_visible => true)

  def add_to_cache
    $redis.sadd("otwtranslation_visible_languages", short)
  end
  
  def remove_from_cache
    $redis.srem("otwtranslation_visible_languages", short)
  end


  def self.translation_visible?(language_short)
     $redis.sismember("otwtranslation_visible_languages", language_short)
  end

end
