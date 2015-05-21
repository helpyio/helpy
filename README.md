Helpy: A Modern Helpdesk Alternative
====================================

Helpy is a modern, "mobile first" helpdesk solution written in Ruby on Rails 4.2 and released under the MIT license. It includes the following:

Planned Features
========

- **Private Support Discussions (aka tickets):**
Integrated with inbound email via Sendgrid, Mandrill, Mailgun, etc. [90%]
- **Community Support Forums:** Customers and Agents can both answer questions in a publicly accessible forum. [90%]
- **Knowledgebase:** Full text searchable and SEO optimized to help users answer questions before they contact you. [95%]
- **Pre-wired for Google Analytics:**  Using a combination of JS and Measurement Protocol tags, Helpy is prewired to track everything from article satisfaction to what your agents are doing. [90%]
- **Mobile-first:** Support requests come at all times, and Helpy works on all devices, out of the box so you can delight customers with prompt answers, from anywhere and at anytime! [90%]
- **Multi-lingual:** At launch we will support English, French, Spanish, German and Russian.  [15%]

Live Demo
---------

http://demo.helpy.io/


Roadmap
-------

- Improve test coverage.
- Handle attachments in tickets, images in knowledgebase
- Insert link to KB articles into reply in admin
- Continue to clean up and remove cruft (this is based on an old rails 2 project)
- Bring back labels (tag) functionality for discussions.  This is partially there now, but is not in the UI yet.
- Multiple agent/admin roles (basic version stubbed in already)
- Omniauth login, with import of user avatars
- Some kind of rules capability linked to tagging, etc.
- Dynamic/Behavioral Personalization


Installation
============

Helpy was designed to run on Heroku, although it should work just about anywhere. Requirements are:

- Ruby 2.2
- Rails 4.2
- Postgres
- Uses Unicorn (right now)

The rest of the instructions are coming soon. The core app is still somewhat unstable so it would be best to hold off right now, unless you just wanna play.



Contributing
============

The core app is still somewhat unstable so it would be best to hold off right now.

1. Fork
2. Create a Branch for your contribution
3. Write tests to cover your enhancements
4. Submit a pull request




License
=======

Copyright 2015, Scott Miller. Helpy is released under the MIT open source license.  Please contribute back any enhancements you make, even though you don't have to.  

Also, I would appreciate if you kept the "powered by Helpy" blurb in the footer.  This helps me keep track of how many are using Helpy.
