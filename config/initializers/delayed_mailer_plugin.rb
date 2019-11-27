# https://github.com/influitive/apartment/pull/436
# config/initializers/delayed_tenant_plugin.rb

# Set SMTP from our settings so the job has it

class DelayedMailerPlugin < Delayed::Plugin
  callbacks do |lifecycle|
    lifecycle.around :perform do |worker, job, *args, &block|
        # Set up mailer
        ActionMailer::Base.smtp_settings = {
            :address              => AppSettings["email.mail_smtp"],
            :port                 => AppSettings["email.mail_port"],
            :user_name            => AppSettings["email.smtp_mail_username"].presence,
            :password             => AppSettings["email.smtp_mail_password"].presence,
            :domain               => AppSettings["email.mail_domain"],
            :enable_starttls_auto => !AppSettings["email.mail_smtp"].in?(["localhost", "127.0.0.1", "::1"])
        }
        puts "SMTP: #{AppSettings["email.mail_smtp"]} PORT: #{AppSettings["mail.email_port"]}"
        block.call(worker, job, *args)
    end
  end
end
 # register this plugin
Delayed::Worker.plugins << DelayedMailerPlugin
