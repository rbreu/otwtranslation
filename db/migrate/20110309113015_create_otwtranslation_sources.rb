class CreateOtwtranslationSources < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_sources do |t|
      t.string :controller_action
      t.string :url
    
      t.timestamps
    end

    add_index(:otwtranslation_sources, :controller_action, :unique => true)
  end

  def self.down
    drop_table :otwtranslation_sources
    drop_index :otwtranslation_sources
  end
end
