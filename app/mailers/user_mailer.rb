class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  layout 'mailer'

  def new_user(user_id, token)
    return unless (AppSettings['settings.welcome_email'] == "1" || AppSettings['settings.welcome_email'] == true)
    @user = User.find(user_id)

    # Do not send to temp email addresses
    return if @user.email.split("@")[0] == "change"

    @token = token
    @locale = I18n.locale.to_s
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: t('new_user_subject', site_name: AppSettings['settings.site_name'])
      )
  end

end
