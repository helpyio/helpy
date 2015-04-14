class TopicMailer < MandrillMailer::MessageMailer

  default from: Settings.admin_email

  def new_ticket(topic)

    mandrill_mail(
      subject: "[#{Settings.site_name}] #{topic.name}",
      to: topic.user.email,
      html: "<!DOCTYPE html>
      <html>
        <head>
          <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
        </head>
        <body>
        <p>
          Make sure your reply appears above this line<br/>
          =================================================================<br/>
          Message ID:#{topic.id}</br>
        </p>
        <p>
          Hello #{topic.user.login},
        </p>
        <p>
          The following message has been posted in response to your question:
        </p>
        <p>
          #{topic.posts.last.body}
        </p>
        <p>
          View this online: #{Settings.site_url}
        </p><br/>
          <p>
          <strong>Powered by Helpy Helpdesk</strong><br/>
          Get a Free Helpy Support System for your Site at https://github.com/scott/help/tree/master
        </p>
        </body>
      </html>",
      text: "// Make sure your reply appears above this line
      // =================================================================
      // Message ID:#{topic.id}

      Hello #{topic.user.login},

      The following message has been posted in response to your question:

      #{topic.posts.last.body}

      View this online: #{Settings.site_url}
      -----------
      Powered by Helpy Helpdesk
      Get a Free Helpy Support System for your Site at https://github.com/scott/helpy/tree/master",

        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: false
     )
  end

end
