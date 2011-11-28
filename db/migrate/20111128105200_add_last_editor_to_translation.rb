class AddLastEditorToTranslation < ActiveRecord::Migration
  def self.up
    add_column :otwtranslation_translations, :last_editor_id, :integer
  end

  def self.down
    remove_column :otwtranslation_phrases, :last_editor_id
  end
end
