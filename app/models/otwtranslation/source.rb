class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  
  has_and_belongs_to_many(:phrases,
                          :join_table => :otwtranslation_phrases_sources,
                          :class_name => 'Otwtranslation::Phrase')

  has_many(:assignments,
           :class_name => 'Otwtranslation::Assignment',
           :foreign_key => 'source_id')

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

  
  def has_phrases_with_current_version?
    return phrases.where(:version => OtwtranslationConfig.VERSION).exists?
  end

  def has_new_phrases?
    return phrases.where(:new => true).exists?
  end

  
  def percentage_translated_for(language)
    all = phrases.count.to_f
    return 0 if all == 0

    translated = connection.select_value("""
    SELECT COUNT(DISTINCT(phrase_key))
    FROM otwtranslation_translations
    WHERE (otwtranslation_translations.language_short = #{connection.quote(language)}
    AND otwtranslation_translations.phrase_key IN
      (SELECT otwtranslation_phrases.key FROM otwtranslation_phrases
       INNER JOIN otwtranslation_phrases_sources
       ON otwtranslation_phrases.id = otwtranslation_phrases_sources.phrase_id
       WHERE (otwtranslation_phrases_sources.source_id = #{id} )))
    """)

    translated/all * 100
  end

  
  def percentage_approved_for(language)
    all = phrases.count.to_f
    return 0 if all == 0

    approved = connection.select_value("""
    SELECT COUNT(DISTINCT(phrase_key))
    FROM otwtranslation_translations
    WHERE (otwtranslation_translations.language_short = #{connection.quote(language)}
    AND otwtranslation_translations.approved = #{connection.quoted_true}
    AND otwtranslation_translations.phrase_key IN
      (SELECT otwtranslation_phrases.key FROM otwtranslation_phrases
       INNER JOIN otwtranslation_phrases_sources
       ON otwtranslation_phrases.id = otwtranslation_phrases_sources.phrase_id
       WHERE (otwtranslation_phrases_sources.source_id = #{id} )))
    """)
    
    
    approved/all * 100
  end
  
end
