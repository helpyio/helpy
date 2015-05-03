class UserMailer < MandrillMailer::MessageMailer

  default from: "#{Settings.admin_email}"

  def new_user(user)

    mandrill_mail(
      subject: "Welcome to #{Settings.site_name}]",
      to: user.email,
      from_name: "noreply@#{Settings.site_name}",
      html: "<!DOCTYPE html>
      <html>
        <head>
          <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
        </head>
        <body>
        <p>
          Hello #{user.name},
        </p>
        <p>
          Thank you for submitting your question to us.  We will be in touch shortly with a
          response.  In the mean time, we wanted to email your passwors to you, so you
          can log in again.
        </p>
        <p>
          Log In here: <a href='#{Settings.site_url}/'>#{Settings.site_url}</a><br/>
          Email: #{user.email}<br/>
          Password: #{user.password}<br/>
        </p><br/>

          <p>
          <strong>Powered by Helpy</strong><br/>
          Get a Free Helpy Support System for your Site at <a href='http://helpy.io/'>http://helpy.io</a>
        </p>
        </body>
      </html>",
      text: "
      Hello #{user.name},

      Thank you for submitting your question to us.  We will be in touch shortly with a
      response.  In the mean time, we wanted to email your passwors to you, so you
      can log in again.

      Log In here: #{Settings.site_url}
      Email: #{user.email}
      Password: #{user.password}

      -----------
      Powered by Helpy Helpdesk
      Get a Free Helpy Support System for your Site at http://helpy.io/",

        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: false
     )
  end

end
