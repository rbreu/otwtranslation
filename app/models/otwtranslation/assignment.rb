class Otwtranslation::Assignment < ActiveRecord::Base
  include HtmlCleaner

  self.table_name = :otwtranslation_assignments

  has_many(:parts, :class_name => 'Otwtranslation::AssignmentPart',
           :foreign_key => 'assignment_id', :order => 'position',
           :dependent => :destroy)
  
  belongs_to(:source, :class_name => 'Otwtranslation::Source',
             :foreign_key => 'source_id')

  belongs_to(:language, :class_name => 'Otwtranslation::Language',
             :primary_key => 'locale', :foreign_key => 'locale')

  has_many(:assignees, :class_name => 'User', :foreign_key => 'user_id',
           :through => :parts, :autosave => true, :order => 'position')

  validates_presence_of :language

  attr_protected :description_sanitizer_version
  
  def set_assignees(assignees)
    parts.each { |p| p.destroy }
    
    assignees.each do |ass|
      if ass.is_a?(Pseud)
        user = ass.user
        login = ass.user.login
      elsif ass.is_a?(User)
        user = ass
        login = ass.login
      else
        user = User.find_by_login(ass)
        login = ass
      end
      if user.nil?
        errors[:parts] << "No user #{login} found."
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
    assignees.value_of(:login).join(", ")
  end

  def source_controller_action
    source.controller_action unless source.nil?
  end

  
  def self.activated_for(assignee, locale)
    find_by_sql("""
    SELECT * FROM otwtranslation_assignments
    WHERE otwtranslation_assignments.activated = #{connection.quoted_true}
    AND otwtranslation_assignments.locale = '#{locale}'
    AND otwtranslation_assignments.id IN
      (SELECT otwtranslation_assignment_parts.assignment_id
       FROM otwtranslation_assignment_parts WHERE user_id = #{assignee.id})
    """)
  end

  # list of languages where assignee has activated assignments
  def self.assignees_language_names(assignee)
    l = connection.select_rows("""
    SELECT name from otwtranslation_languages
    WHERE otwtranslation_languages.locale IN
    (
      SELECT otwtranslation_assignments.locale FROM otwtranslation_assignments
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
