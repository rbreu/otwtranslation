class Otwtranslation::Assignment < ActiveRecord::Base

  set_table_name :otwtranslation_assignments

  has_many(:parts, :class_name => 'Otwtranslation::AssignmentPart',
           :foreign_key => 'assignment_id', :order => 'position',
           :dependent => :destroy)
  
  belongs_to(:source, :class_name => 'Otwtranslation::Source',
             :foreign_key => 'source_id')

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'short', :foreign_key => 'language_short')

  has_many(:assignees, :class_name => 'User', :foreign_key => 'user_id',
           :through => :parts, :autosave => true)

  validates_presence_of :language

  
  def set_assignees(user_logins)
    parts.each { |p| p.destroy }
    
    user_logins.each do |login|
      user = User.find_by_login(login)
      if user.nil?
        errors[:parts] << "No such user: #{login}"
      else
        part = Otwtranslation::AssignmentPart.new(:assignee => user,
                                                  :assignment => self)
        parts << part
      end
    end
  end


  def completed?
    return false if parts.empty?
    !parts.uncompleted.exists?
  end

  def assignees_names
    assignees.map{|a| a.login}.join(", ")
  end

  def source_controller_action
    source.controller_action unless source.nil?
  end

  
  def self.activated_for(assignee, language_short)
    find_by_sql("""
    SELECT * FROM otwtranslation_assignments
    WHERE otwtranslation_assignments.activated = #{connection.quoted_true}
    AND otwtranslation_assignments.language_short = '#{language_short}'
    AND otwtranslation_assignments.id IN
      (SELECT otwtranslation_assignment_parts.assignment_id
       FROM otwtranslation_assignment_parts WHERE user_id = #{assignee.id})
    """)
  end

  # list of languages where assignee as activated assignments
  def self.assignees_language_names(assignee)
    l = connection.select_rows("""
    SELECT name from languages WHERE languages.short IN
    (
      SELECT otwtranslation_assignments.language_short FROM otwtranslation_assignments
      WHERE otwtranslation_assignments.activated = #{connection.quoted_true}
      AND otwtranslation_assignments.id IN
        (SELECT otwtranslation_assignment_parts.assignment_id
         FROM otwtranslation_assignment_parts WHERE user_id = #{assignee.id})
    )
    """)
    l.flatten
  end


  def activate
    self.activated = true
    if self.save
      # notify all assignees
      assignees.each do |assignee|
        Otwtranslation::AssignmentMailer
          .assignment_notification(assignee.id, id).deliver
      end

      # activate first part
      parts.first.activate unless parts.first.nil?
    end
  end

  def users_turn?(user)
    active_part = parts.active
    if active_part.nil?
      return false
    else
      return active_part.assignee == user
    end
  end

end
