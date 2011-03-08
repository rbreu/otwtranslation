class CreateOtwtranslationPhrases < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_phrases do |t|
      t.string :key
      t.string :label
      t.string :description
      t.string :locale

      t.timestamps
    end
  end

  def self.down
    drop_table :otwtranslation_phrases
  end
end
