# Set defaults for outgoing mail.
class ApplicationMailer < ActionMailer::Base
  default from: 'Captain Santa <santa@secretsanta.com>'
  layout 'mailer'
end
