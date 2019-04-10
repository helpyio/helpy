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
  thumbnail: '',
  medium_image: '',
  large_image: '',
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


tag = ActsAsTaggableOn::Tag.create(name: 'sales', description: 'Sales Inquiries')
ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")

tag = ActsAsTaggableOn::Tag.create(name: 'billing', description: 'Billing Inquiries')
ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")

tag = ActsAsTaggableOn::Tag.create(name: 'tier_one', description: 'Tier one support')
ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")

tag = ActsAsTaggableOn::Tag.create(name: 'tier_two', description: 'Tier two support')
ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")


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
  name: "Doc comments",
  description: "Contains comments to docs",
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
Category.create(name:'Common Replies', title_tag: 'Common Agent Replies', meta_description: 'Common replies to questions (Visible only to agents)', front_page: false, active: false, visibility: 'internal')
templates = Category.create(name:'Email templates', title_tag: 'Email Templates',  meta_description: 'Emails used by the system', front_page: false, active: false, visibility: 'internal')
Category.create(name:'Getting Started',icon: 'eye-open', title_tag: 'Getting Started',meta_description:'Learn how to get started with our solution', front_page: true)
Category.create(name:'Top Issues',icon: 'exclamation-sign', title_tag: 'Solutions to Top Issues',meta_description:'Answers to our most frequent issues', front_page: true)
Category.create(name:'General Questions', icon: 'question-sign', title_tag: 'Answers General Questions',meta_description:'If you have a question of a more general nature, you might find the answer here', front_page: true)
Category.create(name:'Troubleshooting', icon: 'ok-circle', title_tag: 'Troubleshooting',meta_description:'Got a problem? Start here to learn more about solving it', front_page: true)

# Create email header and footer tempalte

templates.docs.create!(title: 'Customer_header', body: '<!-- -->')
templates.docs.create!(title: 'Customer_footer', body:'<p style="color: #666;">
<small>
<strong>Powered by Helpy</strong><br>
Get a Free Helpy Support System for your Site at
<a href="https://helpy.io/">https://helpy.io/</a>
</small>
</p>
<p style="color: #666;"><small>%ticket_link%</small></p>')


# Create first example tickets
topic = Forum.first.topics.create(
  name: 'Asking for a favor... give us a star!',
  private: true,
  assigned_user_id: user_admin.id,
  user_id: user_scott.id,
  current_status: 'pending',
  channel: 'install',
  tag_list: 'example tag, welcome, important'
)

topic.posts.create(
  body: '
  Thank you so much for checking out Helpy! I have a favor to ask... If you like what 
  we are doing with Helpy, please take a moment and give the project a star on GitHub. 
  Take a look in the lower right corner of the Helpy UI and you will see a little icon
  showing how many stars the open source version already has.  Just click this and then
  click again on GitHub to give your star.
  ',  
  user_id: user_scott.id,
  kind: 'first'
)

# Create first example tickets
topic = Forum.first.topics.create(
  name: 'Welcome to Helpy',
  private: true,
  assigned_user_id: user_admin.id,
  user_id: user_scott.id,
  current_status: 'pending',
  channel: 'install',
  tag_list: 'welcome, important'
)

topic.posts.create(
  body: '
  Thanks for installing Helpy and giving it a try  <img src="https://github.githubassets.com/images/icons/emoji/unicode/1f389.png?v8" style="width:20px;"><img src="https://github.githubassets.com/images/icons/emoji/unicode/1f31f.png?v8" style="width:20px;"><img src="https://github.githubassets.com/images/icons/emoji/unicode/1f4a5.png?v8" style="width:20px;"><img src="https://github.githubassets.com/images/icons/emoji/unicode/1f525.png?v8" style="width:20px;"><img src="https://github.githubassets.com/images/icons/emoji/unicode/1f4aa.png?v8" style="width:20px;">

  As the founding creator of Helpy, I am excited you decided to give it a look
  and I really hope you use it in your business. I have heard from a lot of you
  that Helpy is the best open source customer support solution out there, and is
  better than even most commercial choices, so thanks for that if you are included
  in this group.   <img src="https://github.githubassets.com/images/icons/emoji/unicode/1f4af.png?v8" style="width:20px;">

  <b>What is Helpy?</b>

  Helpy is a software platform that provides everything you need to run an awesome
  ticketing helpdesk and self service helpcenter website. You can even run a support
  forum where customers can help each other.&nbsp; The best part is Helpy core is 100%
  open source.

  <b>License, Open Core</b>

  Helpy is licensed under the MIT license, which means you can do, well, pretty
  much anything you want with it, other than removing the copyright/credits. Helpy
  is an open core application, which means the core functionality is open source,
  but there is additional functionality you can get if you purchase a license to 
  the enhanced version.


  <b>Support Open Source development by upgrading to Helpy Cloud</b>

  This installation of Helpy can easily be upgraded to the full Helpy Cloud 
  edition. Upgrading gets you access to our private gem server and a license to use 
  all of the cloud tier addons which are not open source and add amazing capabilities 
  like:

  <ul>
    <li>In App Notifications</li>
    <li>Realtime UI</li>
    <li>Advanced Reporting</li>
    <li>Advanced Search</li>
    <li>Triggers</li>
    <li>Custom Views</li>
    <li>LDAP</li>
    <li>Protected Helpcenter</li>
    <li>Carin the Customer Service Chatbot</li>
    <li>Agent Collision Detection</li>
    <li>Helpy Chat (coming soon)</li>
  </ul>

  <a href="https://helpy.io/on-premise" target="_blank" class="btn btn-default">Purchase Now</a><br/>
  A full, current comparison of Helpy options is available here: <a href="https://helpy.io/open-source-helpdesk/">Comparison</a>

  <b>Sponsorship Opportunities</b>

  Helpy is the leading open source helpdesk on GitHub, has over 100,000 Docker installs, 
  and has been featured on Product Hunt numerous times.  We have amassed a large audience of 
  developers, open source users, startups and CIO/CTO types.

  If your business sells to these types of people and you value aligning with the open
  source movement, sponsoring Helpy makes a lot of sense:

  The proceeds from supporters, sponsors and paying customers goes right back into
  further platform development. &nbsp;Supporting the project in some way makes good
  sense if you use Helpy in your business.

  <a href="https://www.patreon.com/helpyio" target="_blank" class="btn btn-default">Become a Supporter <img src="https://github.githubassets.com/images/icons/emoji/unicode/1f4aa.png?v8" style="width: 20px;"></a>
  ',
  user_id: user_scott.id,
  kind: 'first'
)
