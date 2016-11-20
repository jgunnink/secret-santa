# This class' sole purpose is to send a mailer as a separate process to the
# controller action.
class List::ThankyouNotification < ActiveJob::Base
  queue_as :default

  def create_confirmation(list)
    ThankyouMailer.notify_user(list).deliver_later
  end
end
