class Otwtranslation::Source < ActiveRecord::Base

  set_table_name :otwtranslation_sources
  
  def self.find_or_create(controller, uri="")
    find_by_controller(controller) || create(:controller => controller, 
                                             :uri => uri)
  end

end
