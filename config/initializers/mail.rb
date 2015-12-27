ActionMailer::Base.smtp_settings = {
    :address   => "smtp.sendgrid.net",
    :port      => 587,
    :user_name => Settings.mail_username,
    :password  => Settings.mail_api_key,
    :domain    => 'heroku.com'
  }
