class Otwtranslation::Language < ActiveRecord::Base
  
  validates_presence_of :locale
  validates_uniqueness_of :locale
  validates_presence_of :name

  self.table_name = :otwtranslation_languages

  has_many(:translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'locale', :primary_key => 'locale')

  has_many(:approved_translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'locale', :primary_key => 'locale',
           :conditions => {:approved => true} )

  after_destroy :remove_from_cache
  after_save :add_to_cache

  def to_param
    locale
  end

  def percentage_translated
    all = Otwtranslation::Phrase.count.to_f
    return 0 if all == 0
    translated = translations.select("DISTINCT(phrase_key)").count.to_f
    translated/all * 100
  end
    
  def percentage_approved
    all = Otwtranslation::Phrase.count.to_f
    return 0 if all == 0
    translated = approved_translations.select("DISTINCT(phrase_key)").count.to_f
    translated/all * 100
  end

  def self.current_locale
    Thread.current[:otwarchive_locale]
  end
  
  def self.current_locale=(locale)
    Thread.current[:otwarchive_locale] = locale
  end
  
  def self.current_locale
    Thread.current[:otwarchive_locale]
  end
  
  def self.current_locale=(locale)
    Thread.current[:otwarchive_locale] = locale
  end
  
  def add_to_cache
    $redis.sadd("otwtranslation_all_languages", locale)
    if translation_visible
      $redis.sadd("otwtranslation_visible_languages", locale)
    else
      $redis.srem("otwtranslation_visible_languages", locale)
    end
    $redis.hset("otwtranslation_language_names", locale, name)
  end
  
  def remove_from_cache
    $redis.srem("otwtranslation_all_languages", locale)
    $redis.srem("otwtranslation_visible_languages", locale)
    $redis.hdel("otwtranslation_language_names", locale)
  end

  def self.translation_visible_for?(user, locale)
    ## TODO: all languages should only be visible if translation tools
    ## are enabled
    if user && user.is_translation_admin?
      $redis.sismember("otwtranslation_all_languages", locale)
    else
      $redis.sismember("otwtranslation_visible_languages", locale)
    end
  end

  def self.all_locales
    $redis.smembers("otwtranslation_all_languages")
  end

  def self.language_choices_for(user)
    if user && user.is_translation_admin?
      locales = $redis.smembers("otwtranslation_all_languages")
    else
      locales = $redis.smembers("otwtranslation_visible_languages")
    end
    names = $redis.hgetall("otwtranslation_language_names")

    choices = []
    locales.each do |locale|
      choices << [names[locale], locale]
    end
    choices.sort
  end
end
