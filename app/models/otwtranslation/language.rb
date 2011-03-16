class Otwtranslation::Language < Language
  
  scope :visible, where(:translation_viewable => true)
  
end
