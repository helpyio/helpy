#class TopicMailer < MandrillMailer::MessageMailer
class TopicMailer < ActionMailer::Base
  default from: "#{Settings.admin_email}"

  def new_ticket(topic)
    @topic = topic
    email_with_name = %("#{topic.user.name}" <#{topic.user.email}>)
    mail(to: email_with_name, subject: "[#{Settings.site_name}] ##{topic.id}-#{topic.name}")
  end

end
