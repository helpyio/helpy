class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  add_template_helper(RtlHelper)

  default from: "from@example.com"
  layout 'mailer'
end
