class UserMailer < ActionMailer::Base

  default from: Settings.from_email

  def new_user(user)
    @user = user
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(to: email_with_name, subject: "Welcome to #{Settings.site_name}")
  end

end
