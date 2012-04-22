class CreateOtwtranslationLanguages < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_languages do |t|
    t.string  "locale", :limit => 5
    t.string  "name"
    t.boolean "right_to_left", :default => false
    t.boolean "translation_visible", :default => false
    t.timestamps
  end

    add_index(:otwtranslation_languages, :locale, :unique => true)
  end

  def self.down
    drop_table :otwtranslation_languages
    remove_index :otwtranslation_languages
  end
end
