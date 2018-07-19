namespace :db do
  desc "Create placeholder data for DB"
  task :populate => :environment do
  require 'faker'

  # How many fake objects to create
  number_support_team = 2
  number_users = 5
  number_docs = 3
  number_doc_comments = 0
  number_threads = 0
  number_tickets = 15

  groups = [[0, 'billing'],[1, 'shipping'],[2, 'returns'],[3, '']]

  unless User.where(email: 'admin@test.com')
    admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678', admin: true)
    puts "Created Admin: #{admin_user.name}"
  end

  # Get random user data from https://randomuser.me/documentation#results
  def get_user
    url = 'https://api.randomuser.me/1.1/?nat=us'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)['results'][0]
  end

  # Add Support Team
  company_name = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}"
  number_support_team.times.each_with_index do |item, index|

    user = get_user
    u = User.create(
      name: "#{user['name']['first']} #{user['name']['last']}" ,
      email: user['email'],
      login: '',
      password: '12345678',
      admin: true,
      role: 'agent',
      company: "#{company_name}",
      street: user['location']['street'],
      city: user['location']['city'],
      state: user['location']['state'],
      zip: user['location']['postcode'],
      work_phone: user['phone'],
      cell_phone: user['cell'],
      thumbnail: user['picture']['large'],
      medium_image: user['picture']['medium'],
      large_image: user['picture']['large'],
      team_list: groups[index][1]
    )
    puts "Created Agent: #{u.name}"
  end

  # Create users with avatars
  number_users.times do

    user = get_user
    u = User.create(
      name: "#{user['name']['first']} #{user['name']['last']}" ,
      email: user['email'],
      account_number: Faker::Number.number(10),
      login: '',
      password: '12345678',
      company: "#{Faker::Company.name}, #{Faker::Company.suffix}",
      street: user['location']['street'],
      city: user['location']['city'],
      state: user['location']['state'],
      zip: user['location']['postcode'],
      work_phone: user['phone'],
      cell_phone: user['cell'],
      thumbnail: user['picture']['large'],
      medium_image: user['picture']['medium'],
      large_image: user['picture']['large'],
    )

    puts "Created User: #{u.name}"
  end

  # Create users without avatars
  number_users.times do

    user = get_user
    u = User.create(
      name: "#{user['name']['first']} #{user['name']['last']}" ,
      email: user['email'],
      account_number: Faker::Number.number(10),
      login: '',
      password: '12345678',
      company: "#{Faker::Company.name}, #{Faker::Company.suffix}",
      street: user['location']['street'],
      city: user['location']['city'],
      state: user['location']['state'],
      zip: user['location']['postcode'],
      work_phone: user['phone'],
      cell_phone: user['cell'],
    )

    puts "Created User: #{u.name}"
  end

  # Create I18n versions for the demo
  Category.all.each do |category|
    category.update(name: "Exemple catégorie traduit en français", locale: :fr)
    category.update(name: "Näide kategooria tõlgitud prantsuse", locale: :et)
    category.update(name: "Exemple categoria traduïda al francès", locale: :ca)
  end

  # Create 10-50 Docs per category
  Category.all.each do |category|
    number_docs.times do
      title = build_kb_title
      doc = category.docs.create!(
        title_tag: title,
        title: title,
        body: Faker::Lorem.paragraphs(rand(1..5)).join('<br/><br/>'),
        meta_description: Faker::Lorem.sentences(1),
        user_id: User.team.sample.id
      )
      puts "Created Doc: #{doc.title}"
    end
  end

  # Create 1 doc for each demo i18n language
  Category.first.docs.first.update(title: "La documentation de soutien Exemple traduit en français" ,body: '', locale: :fr)
  Category.first.docs.first.update(title: "Näide toetust dokumentatsiooni tõlgitud prantsuse" ,body: '', locale: :et)
  Category.first.docs.first.update(title: "Documentació de suport Exemple traduïda al francès" ,body: '', locale: :ca)

  # Create document comment threads for our users
  Doc.all.each do |doc|

    f = Forum.where(name: 'Doc comments').first
    number_doc_comments.times do
      topic = f.topics.create!(
        name: build_question(Faker::Hacker.ingverb + " " + Faker::Hacker.noun),
        user_id: User.customers.sample.id,
        doc_id: doc.id
      )
      post = topic.posts.create!(
        body: Faker::Lorem.paragraphs(rand(1..2)).join('<br/><br/>'),
        user_id: topic.user_id,
        kind: 'first'
      )

      timeseed = rand(1..30)
      Timecop.travel(Date.today-timeseed.days)

      # create posts about this doc
      rand(0..5).times do
        post = topic.posts.create!(
          body: Faker::Lorem.paragraphs(rand(1..2)).join('<br/><br/>'),
          user_id: User.customers.sample.id,
          kind: 'reply'
        )
        puts "Post added to doc"
      end

    Timecop.return
    end
  end

  # Create community threads for our users

  number_threads.times do

    timeseed = rand(1..30)
    Timecop.travel(Date.today-timeseed.days)

    f = Forum.find(rand(3..6))
    topic = f.topics.new
    topic.name = build_question(Faker::Hacker.ingverb + " " + Faker::Hacker.noun)
    topic.user_id = User.customers.sample.id
    if f.private?
      topic.private = true
      puts "Private Ticket Created!"
    else
      puts "Discussion #{topic.name} Added"
    end

    if f.allow_topic_voting == true
      topic.points = rand(0..1000)
    end

    topic.save

    # create first post in thread
    post = topic.posts.create!(
      body: Faker::Lorem.paragraphs(rand(4..8)).join('<br/><br/>'),
      user_id: topic.user_id,
      kind: 'first'
    )
    puts "Post added to topic"

    Timecop.scale(120000)

    rand(2..5).times do
      post = topic.posts.create!(
        body: Faker::Lorem.paragraphs(rand(1..3)).join('<br/><br/>'),
        user_id: User.customers.sample.id,
        kind: 'reply'
      )
      puts "Post added to topic"
    end

    Timecop.return

  end

  # Create back and forth private threads with support staff
  f = Forum.find(1)
  number_tickets.times.each_with_index do |item, index|

      timeseed = rand(1..30)
      Timecop.travel(Date.today-timeseed.days)

      q = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
      question = build_question(q)

      topic = f.topics.create!(
        name: ticket_issue.split("|")[0],
        user_id: User.customers.sample.id,
        private: true,
        assigned_user_id: User.agents.sample.id,
        team_list: ticket_issue.split("|")[1]
      )

      # create first post in thread
      post = topic.posts.create!(
        body: Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>'),
        user_id: topic.user_id,
        kind: 'first'
      )
      puts "Post added to topic"

      Timecop.scale(120000)
      rand(0..5).times do |i|
        post = topic.posts.new
        post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
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

  def build_kb_title
    [
      "Working with a #{Faker::Hacker.noun}",
      "How to use a #{Faker::Hacker.noun}",
      "#{Faker::Hacker.noun} Frequent Questions",
      "Integrating the #{Faker::Hacker.noun}",
      "Complete list of features",
      "Error: #{Faker::Hacker.noun} Exception",
      "How to manage a #{Faker::Hacker.noun}",
      "#{Faker::Hacker.noun} Setup"
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
      "Order ##{Faker::Number.number(8)} #{issue}",
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
