class AddPseudidToComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, :user_id
    add_column :comments, :pseud_id, :integer
  end
  
  def self.down
    add_column :comments, :user_id, :integer
    remove_column :comments, :pseud_id
  end
end
