class TopicMailer < ActionMailer::Base

  def new_ticket(topic)
    @topic = topic
    email_with_name = %("#{topic.user.name}" <#{topic.user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
