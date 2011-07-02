class Otwtranslation::AssignmentPart < ActiveRecord::Base

  set_table_name :otwtranslation_assignment_parts

  belongs_to(:assignment, :class_name => 'Otwtranslation::Assignment',
             :foreign_key => 'assignment_id')
  
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'user_id'
    
  validates_presence_of :assignee
  validates_uniqueness_of :position, :scope => :assignment_id

  acts_as_list :scope => 'assignment_id = \'#{assignment_id}\''

end
