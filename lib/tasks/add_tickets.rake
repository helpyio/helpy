namespace :db do
  desc "Create placeholder data for DB"
  task :add_tickets => :environment do
    require 'faker'
    number_tickets = 10

    # Create back and forth private threads with support staff
    f = Forum.find(1)
    number_tickets.times.each_with_index do |item, index|

      timeseed = rand(1..30)
      Timecop.travel(Date.today-timeseed.days)

      q = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
      question = build_question(q)

      topic = f.topics.create!(
        name: ticket_issue.split("|")[0],
        user_id: User.where(admin: false).sample.id,
        private: true,
        assigned_user_id: User.where(admin: true).sample.id,
        team_list: ticket_issue.split("|")[1]
      )

      # create first post in thread
      post = topic.posts.create!(
        body: Faker::Lorem.paragraphs(number: rand(2..5)).join('<br/><br/>'),
        user_id: topic.user_id,
        kind: 'first'
      )
      puts "Post added to topic"

      Timecop.scale(120000)
      rand(0..5).times do |i|
        post = topic.posts.new
        post.body = Faker::Lorem.paragraphs(number: rand(2..5)).join('<br/><br/>')
        post.kind = 'reply'
        if i.even?
          post.user_id = topic.assigned_user_id
          # could be note
        else
          post.user_id = topic.user_id
        end
        post.save
        puts "Post added to topic"

      end

      #close message?
      status = rand(1..5)
      if status == 5
        topic.current_status = "closed"
      end
      topic.save
      Timecop.return
    end

    # Update pg search
    PgSearch::Multisearch.rebuild(Topic)

    puts 'All done'
  end


  def build_question(q="something")
    [
      "How do I use #{q}?",
      "#{q} is not working!",
      "Need Help!",
      "Setting up #{q}",
      "#{q} initial questions"
    ].sample
  end

  def issue
    [
      "was late|",
      "is damaged|returns",
      "never came|shipping",
      "has something wrong with it|",
      "was not delivered|shipping",
      "is missing a part|",
      "is the wrong color|"
    ].sample
  end

  def question
    [
      "update my billing information?|billing",
      "change my credit card?|billing",
      "request a refund?|",
      "change my address?|",
      "cancel my account?|"
    ].sample
  end

  def ticket_issue
    [
      "Order ##{Faker::Number.number(digits: 8)} #{issue}",
      "My order for a '#{Faker::Commerce.product_name}' #{issue}",
      "I ordered something from you guys and it #{issue}",
      "Late order|shipping",
      "Where is my order!?|",
      "Missing parts|",
      "No packing slip|shipping",
      "what is your phone number?|",
      "I need to return something|returns",
      "Help!|",
      "Do you have a store anywhere?|",
      "How can I #{question}"
    ].sample
  end

  def company_type
    %w(Inc. LLC. Partners .com Company).sample
  end

end
