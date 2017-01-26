class NotificationMailer < ActionMailer::Base

  def new_private(topic_id)
    new_notification(topic_id, User.notifiable_on_private)
  end

  def new_public(topic_id)
    new_notification(topic_id, User.notifiable_on_public)

  end

  def new_reply(topic_id)
    new_notification(topic_id, User.notifiable_on_reply)
  end

  private

  def new_notification(topic_id, notifiable_users)
    return if notifiable_users.count == 0

    @topic = Topic.find(topic_id)
    @recipient = notifiable_users.first
    @bcc = notifiable_users.last(notifiable_users.count-1).collect {|u| u.email}
    mail(
      to: @recipient.email,
      bcc: @bcc,
      from: AppSettings['email.admin_email'],
      subject: "[#{AppSettings['settings.site_name']}] ##{@topic.id}-#{@topic.name}"
      )
  end
end
