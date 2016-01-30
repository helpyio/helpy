class UserMailer < ActionMailer::Base

  default from: Settings.from_email

  def new_user(user, token)
    @user = user
    @token = token
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(to: email_with_name, subject: "Welcome to #{Settings.site_name}")
  end

end
