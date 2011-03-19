class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  
  has_and_belongs_to_many(:phrases,
                          :join_table => :otwtranslation_phrases_sources,
                          :class_name => 'Otwtranslation::Phrase')

  has_and_belongs_to_many(:translations,
                          :join_table => :otwtranslation_sources_translations,
                          :class_name => 'Otwtranslation::Translation')

  has_and_belongs_to_many(:approved_translations,
                          :join_table => :otwtranslation_sources_translations,
                          :class_name => 'Otwtranslation::Translation',
                          :conditions => {:approved => true})

  # has_many(:sources_translations,
  #          :class_name => 'Otwtranslation::SourceTranslation')
  # has_many :translations, :through => :sources_translations
  # has_many :approved_translations, :through => :sources_translations
  
  

  validates_presence_of :controller_action
  validates_uniqueness_of :controller_action

  def self.find_or_create(params)
    find_or_create_by_controller_action(:controller_action => key(params),
                                        :url => params[:url])
  end


  def self.find_by_source(params)
    find_by_controller_action(key(params))
  end


  def self.key(params)
    "#{params[:controller]}##{params[:action]}"
  end
  
  def controller
    controller_action.split("#")[0]
  end

  
  def action
    controller_action.split("#")[1]
  end

  
  def has_phrases_with_current_verion?
    return phrases.where(:version => OtwtranslationConfig.VERSION).exists?
  end

  
  def translations_for(language)
    translations.where(:language_short => language)
  end

  def approved_translations_for(language)
    approved_translations.where(:language_short => language)
  end


  def percentage_translated_for(language)
    all = phrases.count.to_f
    translated = translations_for(language).count.to_f
    puts "!!!!!!!!!!!!!!!!!!"
    puts translated
    translated/all
  end
  
  def percentage_approved_for(language)
    all = phrases.count.to_f
    approved = approved_translations_for(language).count.to_f
    approved/all
  end
  
end
