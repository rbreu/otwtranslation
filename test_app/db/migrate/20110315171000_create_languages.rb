class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string "short", :limit => 4
      t.string "name"
    end

    add_index "languages", ["short"], :name => "index_languages_on_short"

  end

  def self.down
    drop_table :languages
    remove_index :index_languages_on_short
  end
end
