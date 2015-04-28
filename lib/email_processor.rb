class EmailProcessor

  def initialize(email)
    @email = email
    puts @email
  end

  def process
    # scan users DB for sender email
    puts "Searching for user:#{@email.from[:email]}"

    @user = User.where(email: @email.from[:email]).first
    if @user.nil?
      puts "User not found, attempting to create"
      create_user
    else
      puts "User Found: #{@user.id}: #{@user.name}"
    end

    sitename = Settings.site_name

    # parse the email and find or create topic
#    if @email.body.multipart?
#      message = @email.text_part.body.decoded
#    else
#      message = @email.body.decoded
#    end

    message = @email.body

    #mail.multipart? ? message = mail.parts[-1].body.reverse.split('nO')[-1].reverse : message = mail.body.reverse.split('nO')[-1].reverse
    subject = @email.subject

    if subject.include?("[#{sitename}]") # this is a reply to an existing topic

      puts "Initiating Reply..."

      #Clean message
#      message = @email.raw_text
#      puts message

      complete_subject = subject.split("[#{sitename}]")[1].strip
      ticket_number = complete_subject.split("-")[0].split('#')[1].strip

      puts "Ticket Number: #{ticket_number}"

      topic = Topic.find(ticket_number)
      if topic
        puts "Subject match, adding to topic: " + subject.split("[#{sitename}]")[1].strip
      else
        puts "topic not found"
      end

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => 'reply')

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

      puts "No subject match, creating new topic: " + subject
      topic = Forum.first.topics.create(:name => subject, :user_id => @user.id, :private => true)

      #insert post to new topic
      post = topic.posts.create(:body => message, :user_id => @user.id, :kind => 'first')

    end
  end

  def create_user
    # generate user password
    source_characters = "0124356789abcdefghijk"
    password = ""
    1.upto(8) { password += source_characters[rand(source_characters.length),1] }

    # create user
    puts "creating new user #{@email.from[:email]} #{@email.from[:name]}"
    @user = User.new
    @user.email = @email.from[:email]
#    @user.name = mail.from.split('@')[0]
#    @user.login = mail.from.split('@')[0]
    @user.name = @email.from[:name]
    @user.password = password
#    @user.password_confirmation = password
    @user.save

    #TODO need to send pasword to user


  end


end
