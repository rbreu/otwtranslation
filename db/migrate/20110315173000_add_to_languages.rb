class AddToLanguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :right_to_left, :boolean, :default => 0
    add_column :languages, :translation_viewable, :boolean, :default => 0
  end

  def self.down
    remove_column :languages, :right_to_left
    remove_column :languages, :translation_viewable
  end
end
