class EmailProcessor

  def initialize(email)
    @email = email
    @tracker = Staccato.tracker(AppSettings['settings.google_analytics_id']) if google_analytics_enabled?
  end

  def process

    # Guard clause to prevent ESPs like Sendgrid from posting over and over again
    # if the email presented is invalid and generates a 500.  Returns a 200
    # error as discussed on https://sendgrid.com/docs/API_Reference/Webhooks/parse.html
    # This error happened with invalid email addresses from PureChat
    return if @email.from[:email].match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).blank?

    # Set attributes from email
    sitename = AppSettings["settings.site_name"]
    email_address = @email.from[:email].downcase
    email_name = @email.from[:name].blank? ? @email.from[:token].gsub(/[^a-zA-Z]/, '') : @email.from[:name]
    message = @email.body.nil? ? "" : encode_entity(@email.body)
    raw = @email.raw_body.nil? ? "" : encode_entity(@email.raw_body)
    to = @email.to.first[:email]
    cc = @email.cc ? @email.cc.map { |e| e[:full] }.join(", ") : nil
    token = @email.to.first[:token]
    subject = check_subject(@email.subject)
    attachments = @email.attachments
    number_of_attachments = attachments.present? ? attachments.size : 0


    if subject.include?("[#{sitename}]") # this is a reply to an existing topic
      EmailProcessor.create_reply_from_email(@email, email_address, email_name, subject, raw, message, token, to, sitename, cc, number_of_attachments)
    elsif subject.include?("Fwd: ") # this is a forwarded message DOES NOT WORK CURRENTLY
      EmailProcessor.create_forwarded_message_from_email(@email, subject, raw, message, token, to, cc, number_of_attachments)
    else # this is a new direct message
      EmailProcessor.create_new_ticket_from_email(@email, email_address, email_name, subject, raw, message, token, to, cc, number_of_attachments)
    end

  # rescue
  #   render status: 200
  end

  # Insert a default subject if subject is missing
  def check_subject(subject)
    subject.blank? ? "(No Subject)" : subject
  end

  def encode_entity(entity)
    !entity.nil? ? entity.encode('utf-8', invalid: :replace, replace: '?') : entity
  end

  def self.handle_attachments(email, post)
    return unless email.attachments.present?
    if AppSettings['cloudinary.cloud_name'].present? && AppSettings['cloudinary.api_key'].present? && AppSettings['cloudinary.api_secret'].present?
      array_of_files = []
      email.attachments.each do |attachment|
        array_of_files << File.open(attachment.tempfile.path, 'r')
      end
      post.screenshots = array_of_files
    else
      post.update(
        attachments: email.attachments
      )
      if post.valid?
        post.save
      end
    end
  end

  def cloudinary_enabled?
    AppSettings['cloudinary.cloud_name'].present? && AppSettings['cloudinary.api_key'].present? && AppSettings['cloudinary.api_secret'].present?
  end

  def google_analytics_enabled?
    AppSettings['settings.google_analytics_enabled'] == '1'
  end

  # Creates a new ticket from an email
  def self.create_new_ticket_from_email(email, email_address, email_name, subject, raw, message, token, to, cc, number_of_attachments)
    @user = User.where("lower(email) = ?", email_address).first
    if @user.nil?
      @user = EmailProcessor.create_user_for_email(email_address, token, email_name)
    end

    topic = Forum.first.topics.create(:name => subject, :user_id => @user.id, :private => true)

    if token.include?("+")
      topic.team_list.add(token.split('+')[1])
      topic.save
      topic.team_list.add(token)
      topic.save
    end

    #insert post to new topic
    message = "-" if message.blank? && number_of_attachments > 0
    post = topic.posts.create(
      body: message,
      raw_email: raw,
      user_id: @user.id,
      kind: "first",
      cc: cc
    )

    # Push array of attachments and send to Cloudinary
    EmailProcessor.handle_attachments(email, post)

    # Call to GA
    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "New Topic", non_interactive: true)
      @tracker.event(category: "Agent: Unassigned", action: "New", label: topic.to_param)
    end
  end

  # Creates a ticket from a forwarded email
  def self.create_forwarded_message_from_email(email, subject, raw, message, token, to, cc, number_of_attachments)

    # Parse from out of the forwarded raw body
    from = raw[/From: .*<(.*?)>/, 1]
    from_token = from.split("@")[0]

    # scan users DB for sender email
    @user = User.where("lower(email) = ?", from).first
    if @user.nil?
      @user = EmailProcessor.create_user_for_email(from, from_token, "")
    end

    #clean message
    message = MailExtract.new(raw).body

    topic = Forum.first.topics.create!(
      name: subject,
      user_id: @user.id,
      private: true
    )

    #insert post to new topic
    message = "-" if message.blank? && number_of_attachments > 0
    post = topic.posts.create!(
      body: raw,
      raw_email: raw,
      user_id: @user.id,
      kind: 'first',
      cc: cc
    )

    # Push array of attachments and send to Cloudinary
    EmailProcessor.handle_attachments(email, post)

    # Call to GA
    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "Forwarded New Topic", non_interactive: true)
      @tracker.event(category: "Agent: Unassigned", action: "Forwarded New", label: topic.to_param)
    end
  end

  # Adds a reply to an existing ticket thread from an email response.
  def self.create_reply_from_email(email, email_address, email_name, subject, raw, message, token, to, sitename, cc, number_of_attachments)      
    @user = User.where("lower(email) = ?", email_address).first
    if @user.nil?
      @user = EmailProcessor.create_user_for_email(email_address, token, email_name)
    end

    complete_subject = subject.split("[#{sitename}]")[1].strip
    ticket_number = complete_subject.split("-")[0].split("#")[1].strip
    topic = Topic.find(ticket_number)

    # insert post to new topic
    message = "-" if message.blank? && number_of_attachments > 0
    post = topic.posts.create(
      body: message,
      raw_email: raw,
      user_id: @user.id,
      kind: "reply",
      cc: cc
    )

    # Push array of attachments and send to Cloudinary
    EmailProcessor.handle_attachments(email, post)

    if @tracker
      @tracker.event(category: "Email", action: "Inbound", label: "Reply", non_interactive: true)
      @tracker.event(category: "Agent: #{topic.assigned_user.name}", action: "User Replied by Email", label: topic.to_param) unless topic.assigned_user.nil?
    end
  end

  def self.create_user_for_email(email_address, token, name)
    # create user
    @user = User.new

    @token, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc

    @user.email = email_address
    @user.name = name.blank? ? token.gsub(/[^a-zA-Z]/, '') : name
    @user.password = User.create_password

    if @user.save
      UserMailer.new_user(@user.id, @token).deliver_later if @user.save
    end
    return @user
  end

end
