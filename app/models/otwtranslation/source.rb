class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  
  has_and_belongs_to_many(:phrases,
                          :join_table => :otwtranslation_phrases_sources,
                          :class_name => 'Otwtranslation::Phrase')

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

  
  def percentage_translated_for(language)
    all = phrases.count.to_f
    return 0 if all == 0

    translated = 0
    phrases.each do |t|
      translated += 1 if t.translations_for(language).count > 0
    end
    
    translated/all * 100
  end

  
  def percentage_approved_for(language)
    all = phrases.count.to_f
    return 0 if all == 0

    approved = 0
    phrases.each do |t|
      approved += 1 if t.approved_translations_for(language).count > 0
    end

    approved/all * 100
  end
  
end
