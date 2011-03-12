class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  
  has_many :phrases, :class_name => "Otwtranslation::Phrase"

  
  def self.find_or_create(params={})
    ca = "#{params[:controller]}##{params[:action]}"
    find_or_create_by_controller_action(:controller_action => ca,
                                        :url => params[:url])
  end

  
  def controller
    controller_action.split("#")[0]
  end

  
  def action
    controller_action.split("#")[1]
  end

  
  def has_phrases_with_current_verion?
    return phrases.where(:version => OtwtranslationConfig.VERSION).count > 0
  end

end
