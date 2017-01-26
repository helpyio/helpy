class PostMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def new_post(post_id)
    @post = Post.find(post_id)
    @topic = @post.topic

    # Do not send to temp email addresses
    return if @topic.user.email.split("@")[0] == "change"

    email_with_name = %("#{@topic.user_name}" <#{@topic.user.email}>)
    @post.attachments.each do |att|
      attachments[att.file.filename] = File.read(att.file.file)
    end
    mail(
      to: email_with_name,
      from: %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>),
      subject: "[#{AppSettings['settings.site_name']}] ##{@topic.id}-#{@topic.name}"
      )
  end

end
