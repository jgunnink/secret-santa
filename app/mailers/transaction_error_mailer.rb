class TransactionErrorMailer < ApplicationMailer
  def notify_new_error(new_payment, response)
    @new_payment = new_payment
    @response = response
    mail(to: "help@secretsanta.website", subject: "List payment error")
  end
end
