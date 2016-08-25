# Preview all emails at http://localhost:3000/rails/mailers/assignment_mailer
class AssignmentMailerPreview < ActionMailer::Preview
  def send_assignment
    AssignmentMailer.send_assignment(FactoryGirl.build(:santa, giving_to: Santa.first.id))
  end
end
