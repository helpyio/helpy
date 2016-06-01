class EmailProcessor

  def initialize(email)
    @email = email
    # puts "Tracking GA: #{Settings.google_analytics_id.to_s}"
    @tracker = Staccato.tracker(Settings.google_analytics_id) if Settings.google_analytics_id.present?
  end

  def process
    # scan users DB for sender email
    @user = User.where('lower(email) = ?', get_email_from_mail.downcase).first
    if @user.nil?
      create_user
    end
    sitename = AppSettings["settings.site_name"]
    message =  get_content_from_mail
    subject = @email.subject
    if subject.include?("[#{sitename}]") # this is a reply to an existing topic
      complete_subject = subject.split("[#{sitename}]")[1].strip
      ticket_number = complete_subject.split("-")[0].split("#")[1].strip
      topic = Topic.find(ticket_number)

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => "reply")
      if @tracker
        @tracker.event(category: "Email", action: "Inbound", label: "Reply", non_interactive: true)
        @tracker.event(category: "Agent: #{topic.assigned_user.name}", action: "User Replied by Email", label: topic.to_param) unless topic.assigned_user.nil?
      end

    elsif subject.include?("Fwd: ") # this is a forwarded message DOES NOT WORK CURRENTLY

      #clean message
      message = MailExtract.new(message).body #do we still need this?

      #parse_forwarded_message(message)
      topic = Forum.first.topics.create(:name => @subject, :user_id => @parsed_user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => @message, :user_id => @parsed_user.id)

    else # this is a new direct message
      topic = Forum.first.topics.create(:name => subject, :user_id => @user.id, :private => true)
      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => "first")
      # Call to GA
      if @tracker
        @tracker.event(category: "Email", action: "Inbound", label: "New Topic", non_interactive: true)
        @tracker.event(category: "Agent: Unassigned", action: "New", label: topic.to_param)
      end
    end
  end

  def create_user
    # create user
    @user = User.new

    @token, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc

    @user.email = get_email_from_mail
    @user.name = get_name_from_mail.blank? ? get_token_from_mail : get_name_from_mail
    @user.password = User.create_password
    if @user.save
      UserMailer.new_user(@user, @token).deliver_later
    end
  end

  def get_name_from_mail
    mail_is_mail ? @email[:from].addrs.first.display_name : @email.from[:name]
  end

  def get_email_from_mail
    mail_is_mail ? @email[:from].addrs.first.address : @email.from[:email]
  end

  def get_token_from_mail
    #this seems to only be there for griddler and co
    @email.from[:token]
  end

  def get_content_from_mail
    if mail_is_mail
      @email.multipart? ? (@email.text_part ? @email.text_part.body.decoded : nil) : @email.body.decoded
    else
      MailExtract.new(@email.body).body
    end
  end

  def mail_is_mail
    @email.class.name == 'Mail::Message'
  end

end
