class Otwtranslation::Translation < ActiveRecord::Base
  
  set_table_name :otwtranslation_translations
  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short')
  belongs_to :phrase, :class_name => 'Otwtranslation::Phrase'

  validates_presence_of :label
  validates_presence_of :phrase
  validates_presence_of :language

end
