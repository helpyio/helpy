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

  def mandrill_send(opts={})
      message = {
        :subject => "[#{Settings.site_name}] #{opts[:subject]}",
        :from_name => "Support @#{Settings.site_name}",
        :from_email => Settings.from_email,
        :html => "#{opts[:html]}",
        :text => "#{opts[:email]}",
        :to =>
              [{"name" => "Some User",
                  "email" => "#{opts[:email]}",
                  "type" => "to"}],
        :global_merge_vars => opts[:global_merge_vars]
        }
      sending = MANDRILL.messages.send_template opts[:template], [], message
      rescue Mandrill::Error => e
        Rails.logger.debug("#{e.class}: #{e.message}")
        raise
  end



end
