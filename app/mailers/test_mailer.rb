class TestMailer < ApplicationMailer
  layout 'mailer'

  def new_test(recipient)
    mail(
      to: recipient,
      from: "#{AppSettings['settings.site_name']} <#{AppSettings['email.admin_email']}>",
      subject: "[#{AppSettings['settings.site_name']}] Email Test"
      )
  end
end
