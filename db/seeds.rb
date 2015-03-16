# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a user
anon_user = User.create!(name: 'Anonymous', login:'Anon', email: 'anon@test.com', password: '12345678')
admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678')

# Create some categories and docs
category = Category.create(name: 'First Steps', rank: 1)
category.docs.create(title: "Getting Started")
category.docs.create(title: "Setting Up")

#Create some forums and posts
f = Forum.create(name: "Getting Started", description: "If you have questions about where to start, post them here!")
t = f.topics.create(name: "Can't get logged in", user_id: anon_user.id)
t.posts.create(user_id: anon_user.id, body: "A bunch of interesting stuff usually goes here!!!!")
t.posts.create(user_id: admin_user.id, body: "This is where the brilliant and witty reply by someone really smart goes!")
#t.tag
t = f.topics.create(name: "The interface", user_id: anon_user.id)
t.posts.create(user_id: anon_user.id, body: "A bunch of interesting stuff usually goes here!!!!")
t.posts.create(user_id: admin_user.id, body: "This is where the brilliant and witty reply by someone really smart goes!")

#t.tag
