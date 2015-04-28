namespace :db do
  desc "Create placeholder data for DB"
  task :populate => :environment do
  require 'faker'

    unless User.where(email: 'admin@test.com')
      admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678', admin: true)
      puts "Created Admin: #{admin_user.name}"
    end

    # Add Support Team
    4.times do
      user = RUser.new.first
      u = User.new
      u.name = "#{user.name.first_name} #{user.name.last_name}"
      u.email = user.email
      u.login = user.username
      u.password = '12345678'
      u.admin = true
      u.role = 'admin'
      u.thumbnail = user.picture.thumbnail
      u.medium_image = user.picture.medium
      u.large_image = user.picture.large
      u.save

      puts "Created Agent: #{u.name}"
    end

    # Create 100 users
    50.times do

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

      user = RUser.new.first
      u = User.new
      u.name = "#{user.name.first_name} #{user.name.last_name}"
      u.email = user.email
      u.login = user.username
      u.password = '12345678'
      u.company = "#{Faker::Hacker.noun} #{Faker::Hacker.ingverb} #{companytype}"
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

    # Create 10-50 Docs per category
    Category.all.each do |category|
      rand(10..50).times do
        doc = category.docs.new
        title = Faker::Lorem.sentence
        doc.title_tag = "#{title}"
        doc.title = title
        doc.body = Faker::Lorem.paragraphs(rand(1..5)).join('<br/><br/>')
        doc.meta_description = Faker::Lorem.sentences(1)
        doc.save
        puts "Created Doc: #{doc.title}"
      end
    end


    # Create community threads for our users
    rand(30..50).times do
      f = Forum.find(rand(2..5))
      topic = f.topics.new
      topic.name = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
      topic.user_id = rand(6..50)
      if f.private?
        topic.private = true
        puts "Private Ticket Created!"
      else
        puts "Discussion #{topic.name} Added"
      end
      topic.save

      # create first post in thread
      post = topic.posts.new
      post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
      post.user_id = topic.user_id
      post.kind = 'first'
      post.save
      puts "Post added to topic"

      rand(2..5).times do
        post = topic.posts.new
        post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
        post.user_id = rand(2..12)
        post.kind = 'reply'
        post.save
        puts "Post added to topic"
      end
    end

    # Create back and forth private threads with support staff
    f = Forum.find(1)
    rand(30..50).times do

      topic = f.topics.new
      q = Faker::Hacker.ingverb + " " + Faker::Hacker.noun

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

      topic.name = question
      topic.user_id = rand(6..50)
      topic.private = true
      topic.assigned_user_id = rand(1..5)
      topic.save

      # create first post in thread
      post = topic.posts.new
      post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
      post.user_id = topic.user_id
      post.kind = 'first'
      post.save
      puts "Post added to topic"
      rand(1..5).times do |i|
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
    end

    # Update pg search
    PgSearch::Multisearch.rebuild(Topic)

    puts 'All done'
  end
end
