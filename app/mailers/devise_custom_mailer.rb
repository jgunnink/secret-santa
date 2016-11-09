class DeviseCustomMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Needed for 'confirmation_url'
  layout 'mailer'
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    opts[:from] = 'help@secretsanta.website'
    super
  end
end
