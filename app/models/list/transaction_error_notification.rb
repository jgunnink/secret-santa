# This class' sole purpose is to send a mailer as a separate process to the
# controller action.
class List::TransactionErrorNotification < ActiveJob::Base
  queue_as :default

  def create_confirmation(new_payment, response)
    TransactionErrorMailer.notify_new_error(new_payment, response).deliver_later
  end
end
