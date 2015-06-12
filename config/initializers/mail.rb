ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => Settings.mandrill_username,
    :password  => Settings.mandrill_api_key,
    :domain    => 'heroku.com'
  }
