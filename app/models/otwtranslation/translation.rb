class Otwtranslation::Translation < ActiveRecord::Base
  
  set_table_name :otwtranslation_translations

  has_and_belongs_to_many(:sources,
                          :join_table => :sources_translations,
                          :class_name => 'Otwtranslation::SourceTranslation')
  

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')
  belongs_to(:phrase, :class_name => 'Otwtranslation::Phrase',
             :primary_key => 'key', :foreign_key => 'phrase_key')

  validates_presence_of :label
  validates_presence_of :phrase
  validates_presence_of :language

end
