# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def new_private
    NotificationMailer.new_private(1)
  end

  def new_public
    NotificationMailer.new_public(1)
  end

  def new_reply
    NotificationMailer.new_reply(1)
  end

end
