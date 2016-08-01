class NotificationMailer < ActionMailer::Base

  def new_private(topic)
    @topic = topic
    @admin = User.first
    mail(
      to: @admin.email,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_public(topic)
    @topic = topic
    @admin = User.first
    mail(
      to: @admin.email,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_reply(topic)
    @topic = topic
    @admin = User.first
    mail(
      to: @admin.email,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
