Helpy: A Modern Helpdesk Alternative 
====================================

Helpy is a modern, "mobile first" helpdesk solution written in Ruby on Rails 4.2 and released under the MIT license.  The goal of Helpy is to provide an open source alternative to commercial helpdesk solutions like Zendesk or desk.com

[![Build Status](https://img.shields.io/travis/scott/helpy.svg)](https://travis-ci.org/scott/helpy)

![](http://helpy.io/images/HelpyBrowser.png)


Features
========

- **Private Support Discussions (aka tickets):**
Integrated with inbound email via Sendgrid, Mandrill, Mailgun, etc.
- **Community Support Forums:** Customers and Agents can both answer questions in a publicly accessible forum. You can choose to make forums or posts voteable, and select from 3 layout templates (table, grid or Q&A format). Attach images to posts and tickets using Cloudinary.
- **Voting**: Discussion topics and replies support voting.  This lets you easily create a "feature requests" forum or allow registered users to vote up the best replies to a question similar to Quora or Stack Exchange
- **Knowledgebase:** Full text searchable and SEO optimized to help users answer questions before they contact you. Supports images hosted on your own CDN or via Cloudinary.
- **Pre-wired for Google Analytics:**  Using a combination of JS and Measurement Protocol tags, Helpy is prewired to track everything from article satisfaction to what your agents are doing. [95% implemented]
- **Mobile-first:** Support requests come at all times, and Helpy works on all devices out of the box so you can delight customers with prompt answers, from anywhere and at anytime!
- **Multi-lingual:** Helpy is fully multi-lingual and can provide support in multiple languages at the same time.  Currently the app includes translations for English, French, German, Spanish, Catalan, Chinese, Japanese, Russian and Estonian and is easy to translate.  Helpy provides tools for translating your support content and the multilingual support site feature means your customers will only see content translated into their own locale.

Live Demo
---------

Admin User: `admin@test.com` and password: `12345678`

Front End: http://demo.helpy.io/
Admin Panel: http://demo.helpy.io/admin

Roadmap
-------

- More translation files (need help with this)
- Add "related articles" section to knowledgebase
- Add commenting to knowledgebase using community functions (almost done)
- Support for different themes- and easy way to customize look and feel
- Insert link to KB articles into reply in admin
- Set up JSON API hooks, and test
- Convert admin to use react.js
- Continue to clean up and remove cruft (this is based on an old rails 2 project)
- Bring back labels (tag) functionality for discussions.  This is partially there now, but is not in the UI yet.
- Multiple agent/admin roles (basic version stubbed in already)
- Social Media integration (sharing of topics, replies, etc.)
- Some kind of rules capability linked to tagging, etc.
- Pull GA stats into an internal dashboard
- Dynamic/Behavioral Personalization

Installation
============

Helpy was designed to run on Heroku, although it should work just about anywhere.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Requirements are:

- Ruby 2.2
- Rails 4.2
- Postgres
- Unicorn

Helpy leverages three external services to help out:
- an email provider like Sendgrid
- an image manipulation and host (Cloudinary)
- Google Analytics for stats

Sendgrid and Cloudinary have a free tier that should get you started.  To see how to configure Helpy to use Mandrill as your email provider, see the wiki.

How to Install: [http://support.helpy.io](http://support.helpy.io)

Contributing
============

**Helpy needs your help speading the word.  The #1 contribution you could make is to blog, share, post, tweet, and tell people about Helpy.  This will go a long ways towards helping build a sustainable community.**

I am happy to accept contributions of any kind, including feedback and ideas, translations for other locales, and functionality. To submit translations, [please see the guide to translation](http://support.helpy.io/en/knowledgebase/12-Using-Helpy/docs/4-Supported-locales-How-to-Contribute) and send me a gist to your translation file.  For new functionality, follow the standard approach:

1. Fork the project
2. Create a Branch for your contribution
3. Write tests to cover your enhancements, and documentation describing what your feature is/does
4. Submit a pull request

License
=======

Copyright 2015, Scott Miller. Helpy is released under the MIT open source license.  Please contribute back any enhancements you make, even though you don't have to.  

Also, I would appreciate if you kept the "powered by Helpy" blurb in the footer.  This helps me keep track of how many are using Helpy.

[![Analytics](https://ga-beacon.appspot.com/UA-50151-28/helpy/readme?pixel)](https://github.com/igrigorik/ga-beacon)
