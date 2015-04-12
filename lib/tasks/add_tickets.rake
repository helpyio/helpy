namespace :db do
  desc "Create placeholder data for DB"
  task :add_tickets => :environment do
    require 'faker'

    Forum.all.each do |f|
      rand(10..20).times do
        topic = f.topics.new
        topic.name = Faker::Hacker.ingverb + " " + Faker::Hacker.noun
        topic.user_id = rand(2..12)

        topic.private = true
        puts "Private Ticket Created!"

        topic.save
        rand(2..7).times do
          post = topic.posts.new
          post.body = Faker::Lorem.paragraphs(rand(2..5)).join('<br/><br/>')
          post.user_id = rand(2..12)
          post.save
          puts "Post added to topic"
        end
      end
    end
  end
end
