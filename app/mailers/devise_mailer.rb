class DeviseMailer < Devise::Mailer

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise

  def confirmation_instructions(record, token, opts={})
    # code to be added here later
  end

  def reset_password_instructions(record, token, opts={})
    opts[:from] = "noreply@#{AppSettings['settings.site_url']}"
    opts[:subject] = "[#{AppSettings['settings.site_name']}] #{t('devise.mailer.reset_password_instructions.subject')}"
    super
  end

  def unlock_instructions(record, token, opts={})
    # code to be added here later
  end

end
