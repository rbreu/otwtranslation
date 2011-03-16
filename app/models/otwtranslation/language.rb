class Otwtranslation::Language < Language
  
  scope :visible, where(:translation_visible => true)
  
end
