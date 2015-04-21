class TopicMailer < MandrillMailer::MessageMailer

  default from: "#{Settings.admin_email}"

  def new_ticket(topic)

    mandrill_mail(
      subject: "[#{Settings.site_name}] ##{topic.id}-#{topic.name}",
      to: topic.user.email,
      from_name: "#{topic.posts.last.user.name}@#{Settings.site_name}",
      html: "<!DOCTYPE html>
      <html>
        <head>
          <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
        </head>
        <body>
        <p>
        --- Make sure your reply appears above this line ---
        <br/>
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
          View this online: <a href='#{Settings.site_url}/'>#{Settings.site_url}</a>
        </p><br/>
          <p>
          <strong>Powered by Helpy</strong><br/>
          Get a Free Helpy Support System for your Site at <a href='http://helpy.io/'>http://helpy.io</a>
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
