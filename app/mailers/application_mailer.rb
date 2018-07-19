class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: "from@example.com"
  layout 'mailer'
end
