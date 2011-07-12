class CreateOtwtranslationAssignmentParts < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_assignment_parts do |t|
      t.integer :assignment_id
      t.integer :position
      t.integer :user_id
      t.string :notes
      t.boolean :completed, :default => false

      t.timestamps
    end
  end
  
  def self.down
    drop_table :otwtranslation_assignment_parts
  end
end
