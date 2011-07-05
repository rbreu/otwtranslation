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
    parts.each { |p| p.delete }
    
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
    !(parts.where(:completed => false).exists?)
  end

  def assignees_names
    assignees.map{|a| a.login}.join(", ")
  end

  def source_controller_action
    source.controller_action unless source.nil?
  end
end
