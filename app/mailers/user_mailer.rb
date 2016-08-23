class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def new_user(user, token)
    @user = user
    @token = token
    @locale = I18n.locale
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "Welcome to #{AppSettings['settings.site_name']}"
      )
  end

end
