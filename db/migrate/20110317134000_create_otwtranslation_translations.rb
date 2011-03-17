class CreateOtwtranslationTranslations < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_translations do |t|
      t.string :label
      t.boolean :approved, :default => 0
      t.integer :phrase_id
      t.string :language_id

      t.timestamps
    end

  end

  def self.down
    drop_table :otwtranslation_translations
  end
end
