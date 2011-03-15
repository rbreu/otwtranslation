class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  has_and_belongs_to_many(:phrases,
                          :join_table => :otwtranslation_phrases_sources)

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

end
