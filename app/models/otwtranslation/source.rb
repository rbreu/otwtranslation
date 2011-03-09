class Otwtranslation::Source < ActiveRecord::Base
  
  set_table_name :otwtranslation_sources
  
  has_and_belongs_to_many :phrases, :join_table => :otwtranslation_phrases_sources
  
  def self.find_or_create(controller, action, url="")
    source = where(:controller => controller, :action => action).first
    source || create(:controller => controller,
                     :action => action, :url => url)
  end


  def self.destroy_if_orphaned(source)
    source.destroy if source.phrases.count == 0
  end
  
end
