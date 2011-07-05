class CreateOtwtranslationAssignments < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_assignments do |t|
      t.integer :source_id
      t.string :language_short
      t.string :description

      t.timestamps
    end

  end

  def self.down
    drop_table :otwtranslation_assignments
  end
end

