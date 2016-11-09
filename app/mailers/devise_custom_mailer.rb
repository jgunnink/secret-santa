class DeviseCustomMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Needed for 'confirmation_url'
  layout "mailer"
  default template_path: "devise/mailer"

  def confirmation_instructions(record, token, opts={})
    opts[:from] = "confirmations@secretsanta.website"
    opts[:reply_to] = "confirmations@secretsanta.website"
    super
  end
end
