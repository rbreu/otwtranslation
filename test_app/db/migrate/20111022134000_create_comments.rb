class CreateComments < ActiveRecord::Migration
  def self.up
    create_table "comments", :force => true do |t|
      t.integer  "user_id"
      t.text     "content", :null => false
      t.integer  "depth"
      t.integer  "threaded_left"
      t.integer  "threaded_right"
      t.boolean  "is_deleted", :default => false, :null => false
      t.integer  "commentable_id"
      t.string   "commentable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "thread"
      t.boolean  "approved", :default => false, :null => false
      t.boolean  "hidden_by_admin", :default => false, :null => false
      t.datetime "edited_at"
      t.integer  "parent_id"
      t.string   "parent_type"
      t.integer  "content_sanitizer_version", :limit => 2, :default => 0, :null => false
    end
  end
  
  def self.down
    drop_table :comments
  end
end
