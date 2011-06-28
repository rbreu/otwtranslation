class CreateOtwtranslationVotes < ActiveRecord::Migration
  def self.up
    create_table :otwtranslation_votes do |t|
      t.integer :translation_id
      t.integer :user_id
      t.integer :votes, :default => 0
      t.timestamps
    end

  end

  def self.down
    drop_table :otwtranslation_votes
  end
end

