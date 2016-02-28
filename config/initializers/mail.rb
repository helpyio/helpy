ActionMailer::Base.smtp_settings = {
    :address   => Settings.mail_smtp,
    :port      => Settings.mail_port,
    :user_name => Settings.smtp_mail_username,
    :password  => Settings.smtp_mail_password,
    :domain    => Settings.mail_domain
}
