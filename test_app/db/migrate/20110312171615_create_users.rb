class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :login
      t.string :crypted_password
      t.string :salt
      t.string :persistence_token
      t.boolean :translation_admin, :default => false, :null => false
    
      t.timestamps
    end

    add_index("users", :login, :unique => true)

  end

  def self.down
    drop_table :users
    drop_index :users
  end
end
