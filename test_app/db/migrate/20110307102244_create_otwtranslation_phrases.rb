class CreateOtwtranslationPhrases < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_phrases do |t|
      t.string :key
      t.string :label
      t.string :description
      t.string :locale
      t.string :version
      t.integer :source_id

      t.timestamps
    end

    add_index(:otwtranslation_phrases, :key, :unique => true)
  end

  def self.down
    drop_table :otwtranslation_phrases
    drop_index :otwtranslation_phrases
  end
end
