class Otwtranslation::Language < Language
  
  has_many :translations, :class_name => Otwtranslation::Translation
  
  scope :visible, where(:translation_visible => true)
end
