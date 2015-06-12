class DeviseMailer < Devise::Mailer

  def confirmation_instructions(record, token, opts={})
    # code to be added here later
  end

  def reset_password_instructions(record, token, opts={})
    # code to be added here later
  end

  def unlock_instructions(record, token, opts={})
    # code to be added here later
  end

end
