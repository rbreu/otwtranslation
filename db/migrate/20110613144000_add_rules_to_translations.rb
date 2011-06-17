class AddRulesToTranslations < ActiveRecord::Migration
  def self.up
    add_column :otwtranslation_translations, :rules, :string
  end

  def self.down
    remove_column :otwtranslation_translations, :rules,
  end
end
