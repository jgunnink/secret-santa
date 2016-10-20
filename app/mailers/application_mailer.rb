# Set defaults for outgoing mail.
class ApplicationMailer < ActionMailer::Base
  default from: 'Captain Santa <captain-santa@notifications.secretsanta.website>'
  layout 'mailer'
end
