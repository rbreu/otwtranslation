class AddEditedAtToTranslation < ActiveRecord::Migration
  def self.up
    add_column :otwtranslation_translations, :edited_at, :datetime
  end

  def self.down
    remove_column :otwtranslation_translations, :edited_at
  end
end
