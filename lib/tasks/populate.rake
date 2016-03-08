namespace :db do
  desc "Create placeholder data for DB"
  task :populate => :environment do
  require 'faker'

  # How many fake objects to create
  number_support_team = 4
  number_users = 10
  number_docs = rand(5..10)
  number_threads = rand(20..50)
  number_tickets = rand(20..50)

  unless User.where(email: 'admin@test.com')
    admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678', admin: true)
    puts "Created Admin: #{admin_user.name}"
  end

  # Add Support Team
  company = RUser.new
  company_name = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}"

  number_support_team.times do
    user = RUser.new
    u = User.create(
      name: "#{user.first_name} #{user.last_name}",
      email: user.email,
      login: user.username,
      password: '12345678',
      admin: true,
      role: 'admin',
      company: company_name,
      street: company.street,
      city: company.city,
      state: company.state,
      zip: company.postal,
      work_phone: company.phone,
      cell_phone: user.cell,
      thumbnail: user.profile_thumbnail_url,
      medium_image: user.profile_medium_url,
      large_image: user.profile_large_url
    )

    puts "Created Agent: #{u.name}"
  end

  # Create users with avatars
  number_users.times do

    user = RUser.new
    u = User.create(
      name: "#{user.first_name} #{user.last_name}",
      email: user.email,
      login: user.username,
      password: '12345678',
      company: "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}",
      street: user.street,
      city: user.city,
      state: user.state,
      zip: user.postal,
      work_phone: user.phone,
      cell_phone: user.cell,
      thumbnail: user.profile_thumbnail_url,
      medium_image: user.profile_medium_url,
      large_image: user.profile_large_url
    )

    puts "Created User: #{u.name}"
  end

  # Create users without avatars
  number_users.times do

    user = RUser.new
    u = User.create(
      name: "#{user.first_name} #{user.last_name}",
      email: user.email,
      login: user.username,
      password: '12345678',
      company: "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}",
      street: user.street,
      city: user.city,
      state: user.state,
      zip: user.postal,
      work_phone: user.phone,
      cell_phone: user.cell
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
      title = Faker::Lorem.sentence
      doc = category.docs.create!(
        title_tag: title,
        title: title,
        body: Faker::Lorem.paragraphs(rand(1..5)).join('<br/><br/>'),
        meta_description: Faker::Lorem.sentences(1),
        user_id: rand(1..5)
      )
      puts "Created Doc: #{doc.title}"
    end
  end

  # Create 1 doc for each demo i18n language
  Category.first.docs.first.update(title: "La documentation de soutien Exemple traduit en français" ,body: '', locale: :fr)
  Category.first.docs.first.update(title: "Näide toetust dokumentatsiooni tõlgitud prantsuse" ,body: '', locale: :et)
  Category.first.docs.first.update(title: "Documentació de suport Exemple traduïda al francès" ,body: '', locale: :ca)

  # Create community threads for our users

  number_threads.times do

    timeseed = rand(1..30)
    Timecop.travel(Date.today-timeseed.days)

    f = Forum.find(rand(3..6))
    topic = f.topics.new
    topic.name = build_question(Faker::Hacker.ingverb + " " + Faker::Hacker.noun)
    topic.user_id = User.where(admin: false).sample.id
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
        user_id: rand(3..12),
        kind: 'reply'
      )
      puts "Post added to topic"
    end

    Timecop.return

  end

  # Create back and forth private threads with support staff
  f = Forum.find(1)
  number_tickets.times do

      timeseed = rand(1..30)
      Timecop.travel(Date.today-timeseed.days)

      q = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
      question = build_question(q)

      topic = f.topics.create!(
        name: question,
        user_id: User.where(admin: false).sample.id,
        private: true,
        assigned_user_id: User.where(admin: true).sample.id
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

  def company_type
    %w(Inc. LLC. Partners .com Company).sample
  end

end
