class CreateOtwtranslationContextRules < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_context_rules do |t|
      t.string :language_short
      t.integer :position
      t.string :type
      t.string :description
      t.string :conditions
      t.string :actions

      t.timestamps
    end

  end

  def self.down
    drop_table :otwtranslation_context_rules
  end
end

