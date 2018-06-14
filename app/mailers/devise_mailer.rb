class DeviseMailer < Devise::Mailer
  add_template_helper(EmailHelper)

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  # default template_path: 'devise/mailer' # to make sure that your mailer uses the devise
  layout 'mailer'

  def confirmation_instructions(record, token, opts={})
    # code to be added here later
  end

  def reset_password_instructions(record, token, opts={})
    opts[:from] = %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>)
    opts[:reply_to] = %("#{AppSettings['email.admin_email']}")
    opts[:subject] = %([#{AppSettings['settings.site_name']}] #{t('devise.mailer.reset_password_instructions.subject')})
    headers["Reply-To"] = %("#{AppSettings['email.admin_email']}")
    super
  end

  def unlock_instructions(record, token, opts={})
    # code to be added here later
  end

  def invitation_instructions(record, token, opts={})
    @token = token
    opts[:from] = %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>)
    opts[:reply_to] = %("#{AppSettings['email.admin_email']}")
    opts[:subject] = %([#{AppSettings['settings.site_name']}] #{t('devise.mailer.invitation_instructions.subject')})
    devise_mail(record, :invitation_instructions, opts)
  end

end
