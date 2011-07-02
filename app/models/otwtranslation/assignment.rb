class Otwtranslation::Assignment < ActiveRecord::Base

  set_table_name :otwtranslation_assignments

  has_many(:parts, :class_name => 'Otwtranslation::AssignmentPart',
           :foreign_key => 'assignment_id')
  
  belongs_to(:source, :class_name => 'Otwtranslation::Source',
             :foreign_key => 'source_id')

  def self.create(user_logins, source=nil, description=nil)
    
    assignment = super(:source => source, :description => description)
    user_logins.each do |login|
      user = User.find_by_login(login)
      if user.nil?
        assignment.errors[:parts] << "No such user: #{login}"
      elsif
        part = Otwtranslation::AssignmentPart.new(:assignee => user,
                                                  :assignment => assignment)
        assignment.parts << part
      end
    end

    return assignment
  end

  def completed
    !(parts.where(:completed => false).exists?)
  end
end
