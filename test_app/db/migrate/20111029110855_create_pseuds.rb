class CreatePseuds < ActiveRecord::Migration
  def self.up
    create_table "pseuds", :force => true do |t|
      t.integer  "user_id"
      t.string   "name", :null => false
      t.boolean  "is_default", :default => false, :null => false
    end
  end
  
  def self.down
    drop_table :pseuds
  end
end
