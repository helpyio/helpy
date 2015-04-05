class MailProcessor < ActionMailer::Base

  require 'mail_extract'

  def receive(mail)

    # scan users DB for sender email
    puts "Searching for user:#{mail.from.first}"
    @user = User.where(email: mail.from.first).first
    if @user.nil?
      puts "User not found, attempting to create"
      create_user(mail)
    else
      puts "User Found: #{@user.id}: #{@user.name}"
    end

    sitename = Settings.site_name

    # parse the email and find or create topic
    if mail.body.multipart?
      message = mail.text_part.body.decoded
    else
      message = mail.body.decoded
    end


    #mail.multipart? ? message = mail.parts[-1].body.reverse.split('nO')[-1].reverse : message = mail.body.reverse.split('nO')[-1].reverse
    subject = mail.subject

    if subject.include?("[#{sitename}]") # this is a reply to an existing topic

      puts "Initiating Reply..."

      #Clean message
      message = MailExtract.new(message).body
      puts message


      topic = Topic.find_by_name(subject.split("[#{sitename}]")[1].strip)
      if topic
        puts "Subject match, adding to topic: " + subject.split("[#{sitename}]")[1].strip
      else
        puts "topic not found"
      end

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id)

      puts "Post #{post.id} Created"


    elsif subject.include?("Fwd: ") # this is a forwarded message

      puts "Forwarded message..."

      #clean message
      message = MailExtract.new(message).body


      #parse_forwarded_message(message)
      topic = Forum.first.topics.create(:name => @subject, :user_id => @parsed_user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => @message, :user_id => @parsed_user.id)



    else # this is a new direct message

      puts "No subject match, creating new topic: " + mail.subject
      topic = Forum.first.topics.create(:name => mail.subject, :user_id => @user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id)

    end



  end

  def create_user(mail)
    # generate user password
    source_characters = "0124356789abcdefghijk"
    password = ""
    1.upto(8) { password += source_characters[rand(source_characters.length),1] }

    # create user
    logger.info("creating new user #{mail.from}")
    @user = User.new
    @user.email = mail.from
    @user.name = mail.from.split('@')[0]
    @user.login = mail.from.split('@')[0]
    @user.state = 'active'
    @user.activated_at = Time.now
    @user.password = password
    @user.password_confirmation = password
    @user.save
  end

  # get the username, email, subject and message out of the forwarded message
  def parse_forwarded_message(message)

    header = message.split("---------- Forwarded message ----------")[1]
    header = header.split("To:")[0]
    @from = header.split("Date:")[0].gsub(/<\/?[^>]*>/, "").gsub("&lt;","").gsub("&gt;","").split(":")[1].split(" ").last.strip
    @username = @from.split("@")[0]
    @subject = header.split("Subject:").last.gsub(/<\/?[^>]*>/, "").strip
    @message = message.split("<br><br><br>")[1].gsub(/<\/?[^>]*>/, "").strip

    logger.info("message details ====================")
    logger.info(@from)
    logger.info(@username)
    logger.info(@subject)
    logger.info(@message)

    # check if this is a new or existing user
    @parsed_user = User.find(:first, :conditions => ['email = ?', @from])

    if @parsed_user.nil?
      # generate user password
      source_characters = "0124356789abcdefghijk"
      password = ""
      1.upto(8) { password += source_characters[rand(source_characters.length),1] }

      # create user
      logger.info("creating new user #{@username} from forwarded message")
      @parsed_user = User.new
      @parsed_user.email = @from
      @parsed_user.name = @username
      @parsed_user.login = @username
      @parsed_user.state = 'active'
      @parsed_user.activated_at = Time.now
      @parsed_user.password = password
      @parsed_user.password_confirmation = password
      @parsed_user.save
    end

  end

end
