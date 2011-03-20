require 'digest/md5'
require 'ostruct'

class Otwtranslation::Phrase < ActiveRecord::Base

  set_table_name :otwtranslation_phrases
  has_and_belongs_to_many(:sources, 
                          :join_table => :otwtranslation_phrases_sources,
                          :class_name => 'Otwtranslation::Source')
  has_many(:translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'phrase_key', :primary_key => 'key')
  
  has_many(:approved_translations, :class_name => 'Otwtranslation::Translation',
           :foreign_key => 'phrase_key', :primary_key => 'key',
           :conditions => {:approved => true})
  

  after_destroy :remove_from_cache
  after_save :remove_from_cache

  validates_presence_of :key
  validates_uniqueness_of :key
  

  # We want to cache the phrase but can't put it into the cache as is
  # because we would lose some of the foreign key info about the
  # sources we need. So we construct an OpenStruct proxy instead,
  # cache that and return it.
  #
  # As long as we don't want to edit the phrase (which we have no
  # reason to outside of this method) or want to access the sources
  # properly, we are fine. For the rest, use other finder methods to
  # get the phrase directly from the database.
  
  def self.find_or_create(label, description="", source={})
    key = generate_key(label, description)
    phrase = Rails.cache.read(cache_key(key))

    return phrase if phrase &&
      phrase.version == OtwtranslationConfig.VERSION &&
      phrase.sources.include?(Otwtranslation::Source.key(source))

    phrase = find_or_create_by_key(:key => key, 
                                   :label => label, 
                                   :description => description)

    phrase.version = OtwtranslationConfig.VERSION

    source = Otwtranslation::Source.find_or_create(source)
    unless phrase.sources.exists?(source.id)
      phrase.sources << source
    end

    phrase.save
    phrase = phrase.to_cachable
    Rails.cache.write(cache_key(key), phrase)
    return phrase
  end

  
  def self.find_from_cache_or_db(key)
    Rails.cache.fetch(cache_key(key)) do
      phrase = find_by_key(key).to_cachable
      Rails.cache.write(cache_key(key), phrase)
      phrase
    end
  end
  
  
  def self.cache_key(key)
    "otwtranslation_phrase_#{key}"
  end

  
  def self.generate_key(label, description="")
    Digest::MD5.hexdigest("#{label};;;#{description}")
  end

  
  def to_cachable
    p = OpenStruct.new(attributes)
    p.sources = sources.select(:controller_action).map{|s| s.controller_action}
    return p.freeze
  end

  
  def to_param
    key
  end

  def remove_from_cache
    Rails.cache.delete(cache_key)
  end


  def translations_for(language)
    translations.where(:language_short => language)
  end
  

  def approved_translations_for(language)
    approved_translations.where(:language_short => language)
  end
  
end
