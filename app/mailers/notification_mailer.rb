class NotificationMailer < ActionMailer::Base

  def new_private(topic)
    @topic = topic
    mail(
      to: User.with_settings_for('notify_on_private').collect { |u| u.email },
      # cc:
      from: "noreply@#{AppSettings['settings.site_url']}",
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_public(topic)
    @topic = topic
    mail(
      to: User.with_settings_for('notify_on_private').collect { |u| u.email },
      # cc: User.with_settings_for('notify_on_public').collect { |u| u.email },
      from: "noreply@#{AppSettings['settings.site_url']}",
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

  def new_reply(topic)
    @topic = topic
    mail(
      to: User.with_settings_for('notify_on_reply').collect { |u| u.email },
      # cc: User.with_settings_for('notify_on_reply').collect { |u| u.email },
      from: "noreply@#{AppSettings['settings.site_url']}",
      subject: "[#{AppSettings['settings.site_name']}] ##{topic.id}-#{topic.name}"
      )
  end

end
