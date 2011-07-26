class AddIsnewToPhrases < ActiveRecord::Migration
  def self.up
    add_column :otwtranslation_phrases, :new, :boolean, :default => true
  end

  def self.down
    remove_column :otwtranslation_phrases, :new
  end
end
