class AddActivatedToAssignments < ActiveRecord::Migration
  def self.up
    add_column :otwtranslation_assignments, :activated, :boolean, :default => false
  end

  def self.down
    remove_column :otwtranslation_assignments, :activated,
  end
end
