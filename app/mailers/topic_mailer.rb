class TopicMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def new_ticket(topic)
    @topic = topic
    email_with_name = %("#{topic.user.name}" <#{topic.user.email}>)
    @topic.posts.last.attachments.each do |att|
      attachments[att.file.filename] = File.read(att.file.file)
    end
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
