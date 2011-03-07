class CreateTranslationKeys < ActiveRecord::Migration
  def self.up
    create_table :translation_keys do |t|
      t.string :key
      t.string :label
      t.string :description
      t.string :locale
      t.datetime :last_used

      t.timestamps
    end
  end

  def self.down
    drop_table :translation_keys
  end
end
