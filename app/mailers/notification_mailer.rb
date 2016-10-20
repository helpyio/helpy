class NotificationMailer < ActionMailer::Base

  def new_private(topic)
    notifiable = User.notifiable_on_private
    return if notifiable.count == 0

    @topic = topic
    @recipient = notifiable.first
    @bcc = notifiable.last(notifiable.count-1)
    mail(
      to: @recipient,
      bcc: @bcc,
      from: AppSettings['email.admin_email'],
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_public(topic)
    notifiable = User.notifiable_on_private
    return if notifiable.count == 0

    @topic = topic
    @recipient = notifiable.first
    @bcc = notifiable.last(notifiable.count-1)
    mail(
      to: @recipient,
      bcc: @bcc,
      from: AppSettings['email.admin_email'],
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_reply(topic)
    notifiable = User.notifiable_on_private
    return if notifiable.count == 0

    @topic = topic
    @recipient = notifiable.first
    @bcc = notifiable.last(notifiable.count-1)
    mail(
      to: @recipient,
      bcc: @bcc,
      from: AppSettings['email.admin_email'],
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
