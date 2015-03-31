namespace :db do
  desc "Create placeholder data for DB"
  task :populate => :environment do
  require 'faker'

    unless User.where(email: 'anon@test.com')
      anon_user = User.create!(name: 'Anonymous', login:'Anon', email: 'anon@test.com', password: '12345678')
    end
    unless User.where(email: 'admin@test.com')
      admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678', admin: true)
    end

    # Create top level forums
    Forum.create(name: "Getting Started", description: "How to get started")
    Forum.create(name: "Common Questions", description: "Frequently asked questions")
    Forum.create(name: "How To's", description: "Answers to how to do common things")
    Forum.create(name: "Bugs and Issues", description: "Report Bugs here!")

    # Create 10 Categories and 5 Docs per category
    rand(10..15).times do
      category = Category.new
      name = Faker::Hacker.adjective + " " + Faker::Hacker.noun
      category.name = name
      puts "Creating #{name}"
      category.title_tag = "CheatSheet Support: #{name}"
      category.meta_description = Faker::Lorem.sentences(1)
      if category.save
        puts "Category: #{category.name} saved"
      end
      rand(10..50).times do
        doc = category.docs.new
        title = Faker::Lorem.sentence
        doc.title_tag = "CheatSheet Support: #{title}"
        doc.title = title
        doc.body = Faker::Lorem.paragraphs(rand(1..5)).join('<br/><br/>')
        doc.meta_description = Faker::Lorem.sentences(1)
        doc.save
        puts " Doc: #{doc.title}"
      end
    end

    # Create 10 users, 2 topics and 2 posts each
    10.times do
      user = User.new
      user.name = Faker::Name.name
      user.email = Faker::Internet.email
      user.login = Faker::Internet.user_name
      user.password = '12345678'
      user.save
      Forum.all.each do |f|
        rand(2..5).times do
          topic = f.topics.new
          topic.name = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
          topic.user_id = rand(2..12)
          i = rand(1..15)
          if i == 1
            topic.private = true
          end
          topic.save
          rand(2..7).times do
            post = topic.posts.new
            post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
            post.user_id = rand(2..12)
            post.save
          end
        end
      end
    end

    # Update pg search
    PgSearch::Multisearch.rebuild(Topic)

    puts 'All done'
  end
end
