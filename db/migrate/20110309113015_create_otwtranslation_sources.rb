class CreateOtwtranslationSources < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_sources do |t|
      t.string :controller
      t.string :action
      t.string :url
    
      t.timestamps
    end
  end

  def self.down
    drop_table :otwtranslation_sources
  end
end
