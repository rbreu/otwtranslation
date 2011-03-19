class CreateOtwtranslationSourcesTranslations < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_sources_translations, :id => false do |t|
      t.integer :source_id
      t.integer :translation_id
    end
  end

  def self.down
    drop_table :otwtranslation_sources_translations
  end
end
