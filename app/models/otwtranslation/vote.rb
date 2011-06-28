class Otwtranslation::Vote < ActiveRecord::Base

  set_table_name :otwtranslation_votes

  belongs_to(:translation, :class_name => 'Otwtranslation::Translation',
             :foreign_key => 'translation_id')
  
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  
  
  validates_presence_of :translation
  validates_presence_of :owner
  validates_uniqueness_of :user_id, :scope => :translation_id

  def self.vote(translation, user, updown)
    vote = find_or_create_by_translation_id_and_user_id(:owner => user,
                                                        :translation => translation)
    if updown == "up"
      vote.votes = 1
    elsif updown == "down"
      vote.votes  = -1
    else
      raise ArgumentError, "Unknown action for voting (must be 'up' or 'down')"
    end
    vote.save
  end

  def self.votes_sum
    sum(:votes)
  end
  
end
