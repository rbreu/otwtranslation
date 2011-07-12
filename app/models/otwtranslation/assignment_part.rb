class Otwtranslation::AssignmentPart < ActiveRecord::Base

  set_table_name :otwtranslation_assignment_parts

  belongs_to(:assignment, :class_name => 'Otwtranslation::Assignment',
             :foreign_key => 'assignment_id')
  
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'user_id'
    
  validates_presence_of :assignee
  validates_uniqueness_of :position, :scope => :assignment_id

  acts_as_list :scope => 'assignment_id = \'#{assignment_id}\''

  STATUSES = [:pending, :active, :completed]
  
  
  def status
    STATUSES[read_attribute(:status)]
  end

  def status=(stat)
    stat_int = STATUSES.index(stat)
    if stat_int.nil?
      raise ArgumentError, "Unknown status for assignment part: #{stat}"
    end
    write_attribute(:status, stat_int)
  end


  def self.uncompleted
    where("status IN (#{STATUSES.index(:pending)}, #{STATUSES.index(:active)})")
  end

  
  def self.active
    where("status = #{STATUSES.index(:active)}").first
  end


  def activate
    self.status = :active
    self.save
    Otwtranslation::AssignmentMailer
      .assignment_part_notification(assignee.id, assignment.id).deliver
  end
end
