# Sends out the mail to the Santa
class AssignmentMailer < ApplicationMailer
  def send_assignment(santa)
    @santa = santa
    @recipient = find_recipient(@santa)
    @list = @santa.list
    attachments.inline["santa_with_sack.png"] = File.read("#{Rails.root}/app/assets/images/santa_with_sack_med.png")
    mail(to: @santa.email, subject: "Your Secret Santa for #{@list.name}")
  end

  private

  def find_recipient(santa)
    Santa.find(santa.giving_to)
  end
end
