require 'sanitize'

class Otwtranslation::Translation < ActiveRecord::Base

  set_table_name :otwtranslation_translations

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')
  belongs_to(:phrase, :class_name => 'Otwtranslation::Phrase',
             :primary_key => 'key', :foreign_key => 'phrase_key')
  
  # Rules: Array of rule IDs this translation must fulfill to be applied
  serialize :rules

  validates_presence_of :label
  validates_presence_of :phrase
  validates_presence_of :language

  
  validates_each :approved do |translation, attr, value|
    unless validate_approved(translation, value)
      translation.errors.add attr, "Another translation is already approved."
    end
  end


  after_destroy :remove_from_cache
  before_validation :sanitize_label
  after_save :remove_from_cache
  after_initialize :init_rules

  def init_rules
    self.rules ||= []
  end


  # Check if we can set translation.approved to value
  #
  # * We can always set approved to false.
  # * We can set approved to true if there is no approved translation for this
  #   language, phrase and ruleset
  # * We can't set approved to true if there is an approved translation for
  # * the same ruleset or for unspecified ruleset
  def self.validate_approved(translation, value)
    return true if value.blank?
    
    existing = where(:language_short => translation.language_short,
                     :phrase_key => translation.phrase_key,
                     :approved => translation.approved)

    return true if existing.empty?
    
    existing.each do |ex|
      return false if ex.rules.blank? || ex.rules == translation.rules
    end
  
    return true
  end
  
  def self.cache_key(phrase_key, language, rules=[], decorated=false)
    rules = Otwtranslation::ParameterParser.stringify(rules, ",")
    "otwtranslation_for_#{language}_#{phrase_key}_#{rules}#{decorated ? '_decorated' : ''}"
  end

  # Find translations for a specific language
  # Takes a language_short string or a language object
  def self.for_language(language)
    begin
      language = language.short
    rescue NoMethodError
    end
    where(:language_short => language)
  end

  # Find context-aware translations matching a specific set of variables
  # plus non-context-aware translations
  def self.for_context(label, language, variables)
    begin
      language = language.short
    rescue NoMethodError
    end
    rules = Otwtranslation::ContextRule
      .matching_rules(label, language, variables).map{|r| r.id}

    where(:language_short => language).where("rules='#{rules.to_yaml}' OR rules='#{[].to_yaml}'")
  end

  def remove_from_cache
    # only decorated stuff so far
    # only non-context stuff so far
    Rails.cache.delete(self.class.cache_key(phrase_key, language_short, [], true))
  end


  def sanitize_label
    Sanitize.clean!(label, :elements => OtwtranslationConfig.ALLOWED_TRANSLATIONS_HTML)
  end
  
end
