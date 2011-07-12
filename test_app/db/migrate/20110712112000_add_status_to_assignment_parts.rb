class AddStatusToAssignmentParts < ActiveRecord::Migration
  def self.up
    remove_column :otwtranslation_assignment_parts, :completed
    add_column :otwtranslation_assignment_parts, :status, :integer, :limit => 3, :default => 0
  end

  def self.down
    add_column :otwtranslation_assignment_parts, :completed, :boolean, :default => false
    remove_column :otwtranslation_assignments_parts, :status
  end
end
