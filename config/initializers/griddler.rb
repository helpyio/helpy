require 'email_processor'

Griddler.configure do |config|
  config.processor_class = EmailProcessor # CommentViaEmail
  config.processor_method = :process # :create_comment (A method on CommentViaEmail)
  config.reply_delimiter = 'Make sure your reply appears above this line
================================================================='
  config.email_service = :mandrill # :sendgrid :cloudmailin, :postmark, :mandrill, :mailgun
end
