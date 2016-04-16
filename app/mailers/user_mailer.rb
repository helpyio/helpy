class UserMailer < ActionMailer::Base

  def new_user(user, token)
    @user = user
    @token = token
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "Welcome to #{AppSettings['settings.site_name']}"
      )
  end

end
