require 'email_processor'

Griddler.configure do |config|
  unless [:pop3, :imap, :local].include? Settings.mail_service
    config.processor_class = EmailProcessor # CommentViaEmail
    config.processor_method = :process # :create_comment (A method on CommentViaEmail)
    config.reply_delimiter = '--- Make sure your reply appears above this line ---'
    config.email_service = Settings.mail_service # :sendgrid :cloudmailin, :postmark, :mandrill, :mailgun
  end
end
