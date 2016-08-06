class TopicMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def new_ticket(topic)
    @topic = topic
    @locale = "fa" || 'en'
    email_with_name = %("#{topic.user.name}" <#{topic.user.email}>)
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
