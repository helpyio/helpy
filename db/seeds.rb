# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a user
  admin_user = User.create!(
  name: 'Admin',
  login:'admin',
  email: 'admin@test.com',
  password:'12345678',
  role: 'admin',
  admin: true)

  system_user = User.create!(
  name: 'System',
  login:'system',
  email: 'system@test.com',
  password:'12345678',
  role: 'user',
  admin: false)

  scott = User.create!(
  name: 'Scott Miller',
  login: 'scott',
  email: 'scott+demo@helpy.io',
  password: '12345678',
  role: 'user',
  admin: false,
  bio: 'I am the creator of Helpy.io, the open source helpdesk alternative. Welcome to the system!',
  linkedin: 'http://www.linkedin.com/in/optimizeit',
  company: 'Innovio Systems'
  )

  # Create top level forums
  Forum.create(name: "Private Tickets", description: "Private Messages to Support", private: true)
  Forum.create(name: "Trash", description: "Deleted discussions go here", private: true)
  Forum.create(name: "Getting Started", description: "How to get started")
  Forum.create(name: "Common Questions", description: "Frequently asked questions")
  Forum.create(name: "How To's", description: "Answers to how to do common things")
  Forum.create(name: "Bugs and Issues", description: "Report Bugs here!")

  # Create top level KB categories
  Category.create(name:'Common Replies', title_tag: 'Common Agent Replies', meta_description: 'Common replies to questions (Visible only to agents)', front_page: false, active: false)
  Category.create(name:'Email templates', title_tag: 'Email Templates',  meta_description: 'Emails used by the system', front_page: false, active: false)
  Category.create(name:'Getting Started',icon: 'eye-open', title_tag: 'Getting Started',meta_description:'Learn how to get started with our solution', front_page: true)
  Category.create(name:'Top Issues',icon: 'exclamation-sign', title_tag: 'Solutions to Top Issues',meta_description:'Answers to our most frequent issues', front_page: true)
  Category.create(name:'General Questions', icon: 'question-sign', title_tag: 'Answers General Questions',meta_description:'If you have a question of a more general nature, you might find the answer here', front_page: true)
  Category.create(name:'Troubleshooting', icon: 'ok-circle', title_tag: 'Troubleshooting',meta_description:'Got a problem? Start here to learn more about solving it', front_page: true)
  Category.create(name:'How do I...', icon: 'send', title_tag: 'How to Accomplish specific things',meta_description:'Learn how to accomplish many common things with our solution', front_page: true)
  Category.create(name:'FAQ', icon: 'list',title_tag: 'Frequently asked questions',meta_description:'Answers to all of our FAQs', front_page: true)
  Category.create(name:'Billing', icon: 'credit-card',title_tag: 'Billing Support',meta_description:'Start here if you have billing questions', front_page: true)
  Category.create(name:'Expert Tips', icon: 'road',title_tag: 'Billing Support',meta_description:'Start here if you have billing questions', front_page: true)

  # Create first example tickets
  topic = Forum.find(1).topics.create(
  name: 'Welcome to Helpy',
  private: true,
  assigned_user_id: 1,
  user_id: 3,
  current_status: 'pending'
  )

  topic.posts.create(
  body: 'I am the creator of Helpy, and I wanted to take a moment to welcome you to the system.  I am very interested in your feedback, so please visit http://support.helpy.io/ and leave your thoughts there.',
  user_id: 3,
  kind: 'first'
  )
