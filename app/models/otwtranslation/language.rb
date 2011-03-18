class Otwtranslation::Language < Language
  
  has_many(:translations, :class_name => Otwtranslation::Translation,
           :foreign_key => 'language_short', :primary_key => 'short')
  
  scope :visible, where(:translation_visible => true)
end
