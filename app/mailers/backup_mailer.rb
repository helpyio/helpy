class BackupMailer < ApplicationMailer

  def notify_backup_complition(user, model_name)
  	@user = user
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{model_name} backup completed"
      )
  end

end
