# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users
user_admin = User.create!(
  name: 'Admin',
  login:'admin',
  email: 'admin@test.com',
  password:'12345678',
  role: 'admin',
  thumbnail: 'logo.png',
  medium_image: 'logo.png',
  large_image: 'logo.png',
  admin: true
)

user_system = User.create!(
  name: 'System',
  login:'system',
  email: 'system@test.com',
  password:'12345678',
  role: 'user',
  admin: false
)

user_scott = User.create!(
  name: 'Scott Miller',
  login: 'scott',
  email: 'scott+demo@helpy.io',
  password: '12345678',
  role: 'user',
  admin: false,
  bio: 'I am the creator of Helpy.io, the open source helpdesk alternative. Welcome to the system!',
  linkedin: 'http://www.linkedin.com/in/optimizeit',
  thumbnail: '14369.jpg',
  medium_image: '14369.jpg',
  large_image: '14369.jpg',
  company: ''
)

# Forums
Forum.create(
  name: "Private Tickets",
  description: "Private Messages to Support",
  private: true
)
Forum.create(
  name: "Trash",
  description: "Deleted discussions go here",
  private: true
)
Forum.create(
  name: "Questions and Answers",
  description: "Answers to how to do common things",
  layout: 'qna',
  allow_topic_voting: true,
  allow_post_voting: true
)
Forum.create(
  name: "Feature Requests",
  description: "Suggest and vote on what features we should add next!",
  allow_topic_voting: true
)
Forum.create(
  name: "Idea Board",
  description: "Submit Ideas for HR to consider",
  allow_topic_voting: true,
  allow_post_voting: true,
  layout: 'grid'
)
Forum.create(
  name: "Bugs and Issues",
  description: "Report Bugs here!"
)

# Knowledgebase Categories
Category.create(name:'Common Replies', title_tag: 'Common Agent Replies', meta_description: 'Common replies to questions (Visible only to agents)', front_page: false, active: false)
Category.create(name:'Email templates', title_tag: 'Email Templates',  meta_description: 'Emails used by the system (Not implemented)', front_page: false, active: false)
Category.create(name:'Getting Started',icon: 'eye-open', title_tag: 'Getting Started',meta_description:'Learn how to get started with our solution', front_page: true)
Category.create(name:'Top Issues',icon: 'exclamation-sign', title_tag: 'Solutions to Top Issues',meta_description:'Answers to our most frequent issues', front_page: true)
Category.create(name:'General Questions', icon: 'question-sign', title_tag: 'Answers General Questions',meta_description:'If you have a question of a more general nature, you might find the answer here', front_page: true)
Category.create(name:'Troubleshooting', icon: 'ok-circle', title_tag: 'Troubleshooting',meta_description:'Got a problem? Start here to learn more about solving it', front_page: true)

# Create first example tickets
topic = Forum.first.topics.create(
  name: 'Welcome to Helpy',
  private: true,
  assigned_user_id: user_admin.id,
  user_id: user_scott.id,
  current_status: 'pending'
)

topic.posts.create(
  body: 'I am the creator of Helpy, and I wanted to take a moment to welcome you to the system.  I am very interested in your feedback, so please visit http://support.helpy.io/ and leave your thoughts there.',
  user_id: user_scott.id,
  kind: 'first'
)

topic.posts.create(
  body: 'Helpy is largely a project of passion, and represents many hours of time spent coding, researching, developing ideas, documenting features, writing translations and helping to spread the word. This is all contributed for free by a community devoted to building a great customer support helpdesk, and viable alternative to commericial options like Zendesk and Desk.com.

Despite all the gains thus far, we still need YOUR help. If you can do one of the following, please do so to help support the cause. The bigger we can grow the community, the better it will become:

1. Help Spread the Word: If you like what we are doing, please SHARE, TWEET, POST, BLOG and tell all your friends about Helpy. Seriously, this is still a fairly young and little known project. Helping us spread the word is our number one request!

2. Help with I18n: We have had some great translations contributed already. If you translate Helpy to you language and we don’t have it yet, please please please send us a pull request or gist of the yml file.

Thanks in advance for helping us out!',
  user_id: user_scott.id,
  kind: 'reply'
)
