class ReceiveEmailJob < ActiveJob::Base
  queue_as :default

  def perform(email, sitename, google_analytics_enabled, cloudinary_enabled, cloud_name, api_key, api_secret)

    # scan users DB for sender email
    @user = User.where("lower(email) = ?", email[:from][:email].downcase).first
    if @user.nil?
      create_user(email)
    end

    # Initialize Google tracker
    @tracker = Staccato.tracker(AppSettings['settings.google_analytics_id']) if google_analytics_enabled

    # Email attributes
    message = email[:body].nil? ? "" : email[:body]
    raw = email[:raw_text].nil? ? "" : email[:raw_text]
    subject = email[:subject]
    to = email[:to].first[:email]
    token = email[:to].first[:token]
    attachments = email[:attachments]

    # Split for different types of emails
    if subject.include?("[#{sitename}]") # this is a reply to an existing topic
      create_reply(subject, raw, message, token, to, sitename)
    elsif subject.include?("Fwd: ") # this is a forwarded message
      create_forwarded_message(subject, raw, message, token, to)
    else
      create_new_topic(subject, raw, message, token, to)
    end

    # Save attachments
    if attachments.present? && (cloudinary_enabled == true)
      # config cloudinary from passed params
      Cloudinary.config do |config|
        config.cloud_name = cloud_name
        config.api_key = api_key
        config.api_secret = api_secret
        config.secure = true
      end

      array_of_files = []
      attachments.each do |attachment|
        array_of_files << File.open(attachment[:path], 'r')
      end
      @post.screenshots = array_of_files
      @post.save
    elsif attachments.present?
      # Use cloudinary filestore

      array_of_files = []
      attachments.each do |att|
        array_of_files << File.open(att[:path], 'r')
      end
      @post.attachments = array_of_files
      @post.save
    end
  end

  def create_new_topic(subject, raw, message, token, to)
    topic = Forum.first.topics.create(:name => subject, :user_id => @user.id, :private => true)
    # if @email.header['X-Helpy-Teams'].present?
    #   topic.team_list = @email.header['X-Helpy-Teams']

    if token.include?("+")
      topic.team_list.add(token.split('+')[1])
      topic.save
    elsif token != 'support'
      topic.team_list.add(token)
      topic.save
    end

    #insert post to new topic
    # message = "Attachments:" if @email.attachments.present? && @email.body.blank?
    @post = topic.posts.create(
      :body => message.encode('utf-8', invalid: :replace, replace: '?'),
      :raw_email => raw.encode('utf-8', invalid: :replace, replace: '?'),
      :user_id => @user.id,
      :kind => "first"
    )

    # Push array of attachments and send to Cloudinary
    # handle_attachments(@email, post)

    # Call to GA
    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "New Topic", non_interactive: true)
      @tracker.event(category: "Agent: Unassigned", action: "New", label: topic.to_param)
    end
  end

  def create_forwarded_message(subject, raw, message, token, to)
    #clean message
    # message = MailExtract.new(message).body

    #parse_forwarded_message(message)
    topic = Forum.first.topics.create!(
      :name => subject,
      :user_id => @user.id,
      :private => true
    )

    #insert post to new topic
    # message = "Attachments:" if @email.attachments.present? && @email.body.blank?
    @post = topic.posts.create!(
      :body => raw.encode('utf-8', invalid: :replace, replace: '?'),
      :raw_email => raw.encode('utf-8', invalid: :replace, replace: '?'),
      :user_id => @user.id,
      kind: 'first'
    )

    # Push array of attachments and send to Cloudinary
    # handle_attachments(@email, post)

    # Call to GA
    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "Forwarded New Topic", non_interactive: true)
      @tracker.event(category: "Agent: Unassigned", action: "Forwarded New", label: topic.to_param)
    end

  end

  def create_reply(subject, raw, message, token, to, sitename)
    complete_subject = subject.split("[#{sitename}]")[1].strip
    ticket_number = complete_subject.split("-")[0].split("#")[1].strip
    topic = Topic.find(ticket_number)

    # insert post to new topic
    # message = "Attachments:" if @email.attachments.present? && @email.body.blank?
    @post = topic.posts.create(
      :body => message.encode('utf-8', invalid: :replace, replace: '?'),
      :raw_email => raw.encode('utf-8', invalid: :replace, replace: '?'),
      :user_id => @user.id,
      :kind => "reply"
    )

    # Push array of attachments and send to Cloudinary
    # handle_attachments(@email, post)

    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "Reply", non_interactive: true)
      @tracker.event(category: "Agent: #{topic.assigned_user.name}", action: "User Replied by Email", label: topic.to_param) unless topic.assigned_user.nil?
    end

  end

  def create_user(email)
    # create user
    @user = User.new

    @token, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc

    @user.email = email[:from][:email]
    @user.name = email[:from][:name].blank? ? email[:from][:token].gsub(/[^a-zA-Z]/, '') : email[:from][:name]
    @user.password = User.create_password
    if @user.save
      UserMailer.new_user(@user.id, @token).deliver_later
    end

  end

end
