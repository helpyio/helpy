# mailman_app.rb
require 'mailman'

Mailman.config.pop3 = {
  server: "pop.gmail.com",
  port: 995, # you usually don't need to set this, but it's there if you need to
  ssl: true,
  username: 'inbound884',
  password: 'inbound1234'
}

Mailman::Application.run do
  default do

    puts '***************************'
    puts message
    puts '***************************'

    puts "From: #{message.from.first}"
    puts "Subject: #{message.subject}"
    puts "Body: #{message.body}"


    MailProcessor.receive(message)
  end
end
