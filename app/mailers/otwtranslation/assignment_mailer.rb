class Otwtranslation::AssignmentMailer < ActionMailer::Base
  include Resque::Mailer
  include OtwtranslationHelper
  helper :otwtranslation

  layout 'mailer'
  default :from => ArchiveConfig.RETURN_ADDRESS

  def assignment_notification(user_id, assignment_id)
    user = User.find(user_id)
    @assignment = Otwtranslation::Assignment.find(assignment_id)

    mail(:to => user.email,
         :subject => "[#{ArchiveConfig.APP_NAME}] " +
         ts("Upcoming translation assignment for {general::language}", "",
            :language => @assignment.language.name))
  end

  def assignment_part_notification(user_id, assignment_id)
    user = User.find(user_id)
    @assignment = Otwtranslation::Assignment.find(assignment_id)

    mail(:to => user.email,
         :subject => "[#{ArchiveConfig.APP_NAME}] Translation assignment for #{@assignment.language.name}")
  end

end
