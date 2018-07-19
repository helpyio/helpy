class Devise::MailerPreview < ActionMailer::Preview

  def invitation_instructions
    DeviseMailer.invitation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(User.first, "faketoken", {})
  end

end
