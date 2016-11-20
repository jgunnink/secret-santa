class TransactionErrorMailer < ApplicationMailer
  def notify_user(list)
    @list = list
    @email = list.user.email
    @given_names = list.user.given_names
    attachments.inline["santa_with_sack.png"] = File.read("#{Rails.root}/app/assets/images/santa_with_sack_med.png")
    mail(to: @email, subject: "Secret Santa: Thank you for your purchase!")
  end
end
