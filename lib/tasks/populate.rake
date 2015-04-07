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

    # Add agents
    8.times do
      agent = User.new
      agent.name = Faker::Name.name
      agent.email = Faker::Internet.email
      agent.login = Faker::Internet.user_name
      agent.password = '12345678'
      agent.admin = true
      agent.save

      puts "Created Agent: #{agent.name}"
    end

    # Create 100 users
    100.times do
      user = User.new
      user.name = Faker::Name.name
      user.email = Faker::Internet.email
      user.login = Faker::Internet.user_name
      user.password = '12345678'
      user.save

      puts "Created User: #{user.name}"
    end

    # Create top level forums
    Forum.create(name: "Getting Started", description: "How to get started")
    Forum.create(name: "Common Questions", description: "Frequently asked questions")
    Forum.create(name: "How To's", description: "Answers to how to do common things")
    Forum.create(name: "Bugs and Issues", description: "Report Bugs here!")

    # Create top level KB categories
    Category.create(name:'Getting Started',title_tag: 'Getting Started',meta_description:'Learn how to get started with our solution')
    Category.create(name:'Top Issues',title_tag: 'Solutions to Top Issues',meta_description:'Answers to our most frequent issues', front_page: true)
    Category.create(name:'General Questions',title_tag: 'Answers General Questions',meta_description:'If you have a question of a more general nature, you might find the answer here')
    Category.create(name:'Troubleshooting',title_tag: 'Troubleshooting',meta_description:'Got a problem? Start here to learn more about solving it')
    Category.create(name:'How do I...',title_tag: 'How to Accomplish specific things',meta_description:'Learn how to accomplish many common things with our solution')
    Category.create(name:'FAQ',title_tag: 'Frequently asked questions',meta_description:'Answers to all of our FAQs', front_page: true)
    Category.create(name:'Billing',title_tag: 'Billing Support',meta_description:'Start here if you have billing questions')

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

    # Create forum threads for our users

    Forum.all.each do |f|
      rand(10..20).times do
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

    # Update pg search
    PgSearch::Multisearch.rebuild(Topic)

    puts 'All done'
  end
end
