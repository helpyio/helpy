# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def new_private
    NotificationMailer.new_private(Topic.last.id)
  end

  def new_public
    NotificationMailer.new_public(Topic.last.id)
  end

  def new_reply
    NotificationMailer.new_reply(Topic.last.id)
  end

end
