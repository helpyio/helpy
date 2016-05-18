namespace :helpy do
  desc "Run mailman"
  task :mailman => :environment do

    require 'mailman'
    # Mailman.config.poll_interval

    if AppSettings["email.mail_service"] == 'pop3'
      puts 'pop3 config found'
      Mailman.config.pop3 = {
        server: AppSettings['email.pop3_server'],
        ssl: AppSettings['email.pop3_security'] == 'ssl' ? true : false,
        starttls: AppSettings['email.pop3_security'] == 'starttls' ? true : false,
        username: AppSettings['email.pop3_username'],
        password: AppSettings['email.pop3_password']
      }
    end

    if AppSettings["email.mail_service"] == 'imap'
      puts 'imap config found'
      Mailman.config.imap = {
        server: AppSettings['email.imap_server'],
        port: 993, # you usually don't need to set this, but it's there if you need to
        ssl: AppSettings['email.imap_security'] == 'ssl' ? true : false,
        starttls: AppSettings['email.imap_security'] == 'starttls' ? true : false,
        username: AppSettings['email.imap_username'],
        password: AppSettings['email.imap_password']
      }
    end

    Mailman::Application.run do
      # to AppSettings["email.admin_email"] do
      default do
        begin
          EmailProcessor.new(message).process
        rescue Exception => e
          p e
        end
      end
    end
  end
end
