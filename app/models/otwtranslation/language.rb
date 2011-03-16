class Otwtranslation::Language < Language
  
  scope :translation_viewable, where(:translation_viewable => true)
  
end
