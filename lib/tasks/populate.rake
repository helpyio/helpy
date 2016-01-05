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
  company = RUser.new.first
  company_name = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}"

  number_support_team.times do
    user = RUser.new.first
    u = User.new
    u.name = "#{user.name.first_name} #{user.name.last_name}"
    u.email = user.email
    u.login = user.username
    u.password = '12345678'
    u.admin = true
    u.role = 'admin'
    u.company = company_name
    u.street = company.location.street
    u.city = company.location.city
    u.state = company.location.state
    u.zip = company.location.zip
    u.work_phone = company.phone
    u.cell_phone = user.cell
    u.thumbnail = user.picture.thumbnail
    u.medium_image = user.picture.medium
    u.large_image = user.picture.large
    u.save

    puts "Created Agent: #{u.name}"
  end

  # Create users with avatars
  number_users.times do

    user = RUser.new.first
    u = User.new
    u.name = "#{user.name.first_name} #{user.name.last_name}"
    u.email = user.email
    u.login = user.username
    u.password = '12345678'
    u.company = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}"
    u.street = user.location.street
    u.city = user.location.city
    u.state = user.location.state
    u.zip = user.location.zip
    u.work_phone = user.phone
    u.cell_phone = user.cell
    u.thumbnail = user.picture.thumbnail
    u.medium_image = user.picture.medium
    u.large_image = user.picture.large
    u.save

    puts "Created User: #{user.name}"
  end

  # Create users without avatars
  number_users.times do

    user = RUser.new.first
    u = User.new
    u.name = "#{user.name.first_name} #{user.name.last_name}"
    u.email = user.email
    u.login = user.username
    u.password = '12345678'
    u.company = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{company_type}"
    u.street = user.location.street
    u.city = user.location.city
    u.state = user.location.state
    u.zip = user.location.zip
    u.work_phone = user.phone
    u.cell_phone = user.cell
    u.save

    puts "Created User: #{user.name}"
  end

  # Create I18n versions for the demo
  Category.all.each do |category|
    category.attributes = {name: "Exemple catégorie traduit en français", locale: :fr}
    category.save
    category.attributes = {name: "Näide kategooria tõlgitud prantsuse", locale: :et}
    category.save
    category.attributes = {name: "Exemple categoria traduïda al francès", locale: :ca}
    category.save
  end

  # Create 10-50 Docs per category
  Category.all.each do |category|
    number_docs.times do
      doc = category.docs.new
      title = Faker::Lorem.sentence
      doc.title_tag = "#{title}"
      doc.title = title
      doc.body = Faker::Lorem.paragraphs(rand(1..5)).join('<br/><br/>')
      doc.meta_description = Faker::Lorem.sentences(1)
      doc.user_id = rand(1..5)
      doc.save
      puts "Created Doc: #{doc.title}"
    end
  end

  # Create 1 doc for each demo i18n language
  Category.first.docs.first.attributes = {title: "La documentation de soutien Exemple traduit en français" ,body: '', locale: :fr}
  Category.first.docs.first.save
  Category.first.docs.first.attributes = {title: "Näide toetust dokumentatsiooni tõlgitud prantsuse" ,body: '', locale: :et}
  Category.first.docs.first.save
  Category.first.docs.first.attributes = {title: "Documentació de suport Exemple traduïda al francès" ,body: '', locale: :ca}
  Category.first.docs.first.save

  # Create document comment threads for our users

  Doc.all.each do |doc|

    timeseed = rand(1..30)
    Timecop.travel(Date.today-timeseed.days)

    rand(1..5).times do

      f = Forum.where(name: 'Doc comments').first
      topic = f.topics.new
      topic.name = build_question(Faker::Hacker.ingverb + " " + Faker::Hacker.noun)
      topic.user_id = User.where(admin: false).sample.id
      topic.doc_id = doc.id
  #    if f.private?
  #      topic.private = true
  #      puts "Private Ticket Created!"
  #    else
  #      puts "Discussion #{topic.name} Added"
  #    end

  #    if f.allow_topic_voting == true
  #      topic.points = rand(0..1000)
  #    end

      topic.save

      # create first post in thread
      post = topic.posts.new
      post.body = Faker::Lorem.paragraphs(rand(1..2)).join('<br/><br/>')
      post.user_id = topic.user_id
      post.kind = 'first'
      post.save
      puts "Post added to doc"

#      Timecop.scale(120000)

#      rand(2..5).times do
#        post = topic.posts.new
#        post.body = Faker::Lorem.paragraphs(rand(1..3)).join('<br/><br/>')
#        post.user_id = rand(3..12)
#        post.kind = 'reply'
#        post.save
#        puts "Post added to topic"
#      end

#      Timecop.return
    end
  end






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
    post = topic.posts.new
    post.body = Faker::Lorem.paragraphs(rand(4..8)).join('<br/><br/>')
    post.user_id = topic.user_id
    post.kind = 'first'
    post.save
    puts "Post added to topic"

    Timecop.scale(120000)

    rand(2..5).times do
      post = topic.posts.new
      post.body = Faker::Lorem.paragraphs(rand(1..3)).join('<br/><br/>')
      post.user_id = rand(3..12)
      post.kind = 'reply'
      post.save
      puts "Post added to topic"
    end

    Timecop.return

  end

  # Create back and forth private threads with support staff
  f = Forum.find(1)
  number_tickets.times do

      timeseed = rand(1..30)
      Timecop.travel(Date.today-timeseed.days)

      topic = f.topics.new
      q = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
      question = build_question(q)

      topic.name = question
      topic.user_id = User.where(admin: false).sample.id
      topic.private = true
      topic.assigned_user_id = User.where(admin: true).sample.id
      topic.save

      # create first post in thread
      post = topic.posts.new
      post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
      post.user_id = topic.user_id
      post.kind = 'first'
      post.save
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
    question = rand(1..5)
    case question
    when 1
      question = "How do I use #{q}?"
    when 2
      question = "#{q} is not working!"
    when 3
      question = "Need Help!"
    when 4
      question = "Setting up #{q}"
    when 5
      question = "#{q} initial questions"
    end
  end

  def company_type
    company_seed = rand(1..5)
    case company_seed
    when 1
      companytype = "Inc."
    when 2
      companytype = "LLC."
    when 3
      companytype = "Partners"
    when 4
      companytype = ".com"
    when 5
      companytype = "Company"
    end
  end

end
