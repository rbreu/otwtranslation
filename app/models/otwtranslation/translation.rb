require 'sanitize'

class Otwtranslation::Translation < ActiveRecord::Base
  
  set_table_name :otwtranslation_translations

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')
  belongs_to(:phrase, :class_name => 'Otwtranslation::Phrase',
             :primary_key => 'key', :foreign_key => 'phrase_key')

  validates_presence_of :label
  validates_presence_of :phrase
  validates_presence_of :language
  validates_uniqueness_of :approved, :scope => [:phrase_key, :language_short],
                          :allow_blank => true,
                          :message => "Another translation is already approved."

  after_destroy :remove_from_cache
  before_validation :sanitize_label
  after_save :remove_from_cache

  
  def self.cache_key(phrase_key, language, decorated=false)
    "otwtranslation_for_#{language}_#{phrase_key}#{decorated ? '_decorated' : ''}"
  end
  

  def remove_from_cache
    # only decorated stuff so far
    Rails.cache.delete(self.class.cache_key(phrase_key, language_short, true))
  end


  def sanitize_label
    Sanitize.clean!(label, :elements => OtwtranslationConfig.ALLOWED_TRANSLATIONS_HTML)
  end
  
end
