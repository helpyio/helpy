class TopicMailer < ApplicationMailer

  def new_post(topic)
    setup_email(topic)
    @topic = topic
    @subject << " #{topic.name}"
    mail(to: @recipients, subject: @subject)
    #@body[:url] = APP_CONFIG[:site_url]
  end

  protected

  def setup_email(topic)
    @recipients = "#{topic.user.email}"
    @from = Settings.admin_email
    @reply_to = Settings.admin_email
    @subject = "[#{Settings.site_name}] "
    @sent_on = Time.now
    #@body[:topic] = topic
  end

end
