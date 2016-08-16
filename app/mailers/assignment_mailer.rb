class AssignmentMailer < ApplicationMailer

  def send_assignment(santa)
    @santa = santa
    @recipient = find_recipient(@santa)
    @list = @santa.list
    mail(to: @santa.email, subject: "Your Secret Santa for #{@list.name}")
  end

private

  def find_recipient(santa)
    Santa.find(santa.giving_to)
  end

end
