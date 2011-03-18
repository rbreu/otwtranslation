class Otwtranslation::Language < Language
  
  has_many(:translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'language_short', :primary_key => 'short')

  has_many(:approved_translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'language_short', :primary_key => 'short',
           :conditions => {:approved => true} )


  def percentage_translated
    all = Otwtranslation::Phrase.count.to_f
    translated = translations.select("DISTINCT(phrase_key)").count.to_f
    translated/all
  end
    
  def percentage_approved
    all = Otwtranslation::Phrase.count.to_f
    translated = approved_translations.size.to_f
    translated/all
  end
    
  
  scope :visible, where(:translation_visible => true)
end
