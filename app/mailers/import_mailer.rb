class ImportMailer < ApplicationMailer
  layout 'mailer'
  
  def notify_import_complition(user, model_name, notes)
  	@user = user
  	@notes = notes
    email_with_name = %("#{user.name}" <#{user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{model_name} import completed"
      )
  end

end
