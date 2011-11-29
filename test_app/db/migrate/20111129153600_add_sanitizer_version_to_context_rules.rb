class AddSanitizerVersionToContextRules < ActiveRecord::Migration
  def self.up
    add_column(:otwtranslation_context_rules, :description_sanitizer_version,
               :integer, :limit => 2, :default => 0, :null => false)
  end

  def self.down
    remove_column :otwtranslation_context_rules, :description_sanitizer_version
  end
end
