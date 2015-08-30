Helpy: A Modern Helpdesk Alternative
====================================

Helpy is a modern, "mobile first" helpdesk solution written in Ruby on Rails 4.2 and released under the MIT license.

![](http://helpy.io/images/group.png)


Version 1.0 Features
========

- **Private Support Discussions (aka tickets):**
Integrated with inbound email via Sendgrid, Mandrill, Mailgun, etc.
- **Community Support Forums:** Customers and Agents can both answer questions in a publicly accessible forum. You can choose to make forums or posts voteable, and select from 3 layout templates (table, grid or Q&A format). Attach images to posts and tickets using Cloudinary.
- **Voting**: Discussion topics and replies support voting.  This lets you easily create a "feature requests" forum or allow registered users to vote up the best replies to a question.
- **Knowledgebase:** Full text searchable and SEO optimized to help users answer questions before they contact you. Supports images hosted on your own CDN or via Cloudinary.
- **Pre-wired for Google Analytics:**  Using a combination of JS and Measurement Protocol tags, Helpy is prewired to track everything from article satisfaction to what your agents are doing. [95% implemented]
- **Mobile-first:** Support requests come at all times, and Helpy works on all devices out of the box so you can delight customers with prompt answers, from anywhere and at anytime!
- **Multi-lingual:** At launch the app will is ready to translate and include translations for English and French.

Live Demo
---------

http://demo.helpy.io/

Roadmap
-------

- Enhanced support for other languages (need help with this)
- Insert link to KB articles into reply in admin
- Support code formatting in the Knowledgebase
- Continue to clean up and remove cruft (this is based on an old rails 2 project)
- Bring back labels (tag) functionality for discussions.  This is partially there now, but is not in the UI yet.
- Multiple agent/admin roles (basic version stubbed in already)
- Social Media integration (sharing of topics, replies, etc.)
- Omniauth login, with import of user avatars
- Some kind of rules capability linked to tagging, etc.
- Pull GA stats into an internal dashboard
- Dynamic/Behavioral Personalization

Installation
============

Helpy was designed to run on Heroku, although it should work just about anywhere. Requirements are:

- Ruby 2.2
- Rails 4.2
- Postgres
- Unicorn

Helpy leverages three external services to help out:
- an email provider like Mandrill
- an image manipulation and host (Cloudinary)
- Google Analytics for stats

Mandrill and Cloudinary have a free tier that should get you started.  To see how to configure Helpy to use Mandrill as your email provider, see the wiki.

1. To get started, install the app and make sure you seed the database `rake db:seed`  You can also populate the database with fake data by running `rake db:populate`
2. Open up the settings.yml to configure the system.  You will need to add your Mandrill and Google Analytics configs here.
3. Run `rake secret` to secure your app.
4. You will also need to sign up for an API key/account with an email provider.  I like Mandrill, and Helpy ships with the gem, although switching provider should be trivial.  
5. You will also need to sign up for an account with Cloudinary, and complete `cloudinary.yml.config` (remove the .config) with your specific info.

Contributing
============

1. Fork
2. Create a Branch for your contribution
3. Write tests to cover your enhancements, and documentation describing what your feature is/does
4. Submit a pull request

License
=======

Copyright 2015, Scott Miller. Helpy is released under the MIT open source license.  Please contribute back any enhancements you make, even though you don't have to.  

Also, I would appreciate if you kept the "powered by Helpy" blurb in the footer.  This helps me keep track of how many are using Helpy.
