namespace :helpy do
  desc "Run mailman, call with mail_interval=0 to run once"
  task :mailman => :environment do

    interval = ENV['mail_interval'].to_i || 60
    require 'mailman'
    Mailman.config.poll_interval = interval
    Mailman.config.ignore_stdin = true # Ignores STDIN if running CRON job


    configure_mailman

    Mailman::Application.run do
      default do
        begin
          ImapProcessor.new(message).process
        rescue Exception => e
          p e
        end
      end
    end
  end

  def configure_mailman
    if AppSettings["email.mail_service"] == 'pop3'
    #   puts 'pop3 config found'
      pop3_port = AppSettings['email.pop3_port']
      if pop3_port.empty?
        pop3_port = AppSettings['email.pop3_security'] == 'ssl' ? 995 : 110
      end
      Mailman.config.pop3 = {
        server: AppSettings['email.pop3_server'],
        ssl: AppSettings['email.pop3_security'] == 'ssl' ? {ssl_version: :TLSv1_2} : false,
        starttls: AppSettings['email.pop3_security'] == 'starttls' ? true : false,
        username: AppSettings['email.pop3_username'],
        password: AppSettings['email.pop3_password'],
        port: pop3_port
      }
    end

    if AppSettings["email.mail_service"] == 'imap'
      # puts 'imap config found'
      imap_port = AppSettings['email.imap_port']
      if imap_port.empty?
        imap_port = AppSettings['email.imap_security'] == 'ssl' ? 993 : 143
      end
      Mailman.config.imap = {
        server: AppSettings['email.imap_server'],
        ssl: AppSettings['email.imap_security'] == 'ssl' ? {ssl_version: :TLSv1_2} : false,
        starttls: AppSettings['email.imap_security'] == 'starttls' ? true : false,
        username: AppSettings['email.imap_username'],
        password: AppSettings['email.imap_password'],
        port: imap_port
      }
    end
  end

end
