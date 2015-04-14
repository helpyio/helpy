# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a user
#anon_user = User.create!(name: 'Anonymous', login:'Anon', email: 'anon@test.com', password: '12345678')
admin_user = User.create!(
  name: 'Admin',
  login:'admin',
  email: 'admin@test.com',
  password:'12345678',
  admin: true)

  # Create top level forums
  Forum.create(name: "Private Tickets", description: "Private Messages to Support", private: true)
  Forum.create(name: "Getting Started", description: "How to get started")
  Forum.create(name: "Common Questions", description: "Frequently asked questions")
  Forum.create(name: "How To's", description: "Answers to how to do common things")
  Forum.create(name: "Bugs and Issues", description: "Report Bugs here!")

  # Create top level KB categories
  Category.create(name:'Getting Started',icon: 'eye-open', title_tag: 'Getting Started',meta_description:'Learn how to get started with our solution')
  Category.create(name:'Top Issues',icon: 'exclamation-sign', title_tag: 'Solutions to Top Issues',meta_description:'Answers to our most frequent issues', front_page: true)
  Category.create(name:'General Questions', icon: 'question-sign', title_tag: 'Answers General Questions',meta_description:'If you have a question of a more general nature, you might find the answer here')
  Category.create(name:'Troubleshooting', icon: 'ok-circle', title_tag: 'Troubleshooting',meta_description:'Got a problem? Start here to learn more about solving it')
  Category.create(name:'How do I...', icon: 'send', title_tag: 'How to Accomplish specific things',meta_description:'Learn how to accomplish many common things with our solution')
  Category.create(name:'FAQ', icon: 'list',title_tag: 'Frequently asked questions',meta_description:'Answers to all of our FAQs', front_page: true)
  Category.create(name:'Billing', icon: 'credit-card',title_tag: 'Billing Support',meta_description:'Start here if you have billing questions')
  Category.create(name:'Expert Tips', icon: 'road',title_tag: 'Billing Support',meta_description:'Start here if you have billing questions')
