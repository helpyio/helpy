class EmailProcessor


  def initialize(email)
    @email = email
    puts @email

    puts "Tracking GA: #{Settings.google_analytics_id}"
    @tracker = Staccato.tracker(Settings.google_analytics_id)

  end

  def process
    # scan users DB for sender email
    @user = User.where(email: @email.from[:email]).first
    if @user.nil?
      create_user
    end

    sitename = Settings.site_name
    message = @email.body
    subject = @email.subject

    if subject.include?("[#{sitename}]") # this is a reply to an existing topic

      complete_subject = subject.split("[#{sitename}]")[1].strip
      ticket_number = complete_subject.split("-")[0].split('#')[1].strip
      topic = Topic.find(ticket_number)

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => 'reply')

      @tracker.event(category: 'Email', action: 'Inbound', label: 'Reply', non_interactive: true)
      @tracker.event(category: "Agent: #{topic.assigned_user.name}", action: 'User Replied by Email', label: topic.to_param) unless topic.assigned_user.nil?


    elsif subject.include?("Fwd: ") # this is a forwarded message DOES NOT WORK CURRENTLY

      #clean message
      message = MailExtract.new(message).body

      #parse_forwarded_message(message)
      topic = Forum.first.topics.create(:name => @subject, :user_id => @parsed_user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => @message, :user_id => @parsed_user.id)

    else # this is a new direct message

      topic = Forum.first.topics.create(:name => subject, :user_id => @user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => 'first')

      # Call to GA
      @tracker.event(category: 'Email', action: 'Inbound', label: 'New Topic', non_interactive: true)
      @tracker.event(category: 'Agent: Unassigned', action: 'New', label: topic.to_param)

    end
  end

  def create_user

    # create user
    @user = User.new

    @token, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc

    @user.email = @email.from[:email]
    @user.name = @email.from[:name].blank? ? @email.from[:token] : @email.from[:name]
    @user.password = User.create_password
    if @user.save
      UserMailer.new_user(@user, @token).deliver_now
    end

  end


end
