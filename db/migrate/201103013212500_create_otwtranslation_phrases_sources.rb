class CreateOtwtranslationPhrasesSources < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_phrases_sources, :id => false do |t|
      t.integer :phrase_id
      t.integer :source_id
    end
  end

  def self.down
    drop_table :otwtranslation_phrases_sources
  end
end
