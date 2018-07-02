Helpy: A Modern Helpdesk Platform for the Web
====================================

Helpy is a modern omnichannel helpdesk platform written in Ruby on Rails 4.2 and released under the MIT license.  The goal of Helpy is to power your support email and ticketing, integrate seamlessly with your app, and run an amazing customer helpcenter.  

[![Build Status](https://img.shields.io/travis/helpyio/helpy/master.svg)](https://travis-ci.org/helpyio/helpy) [![Code Climate](https://codeclimate.com/github/helpyio/helpy/badges/gpa.svg)](https://codeclimate.com/github/helpyio/helpy)

![](http://helpy.io/images/HelpyBrowser.png)

Sponsor/Support Helpy
========

Helpy is licensed under the MIT license, and is an open-core project. This means that the core functionality is 100% open source and fully hackable or even re-sellable under the MIT license.  See the features comparison below to understand what is included.  

Helpy is a large system and cannot exist purely as a hobby project. If you use it in a money generating capacity, it makes good sense to support the project financially or by becoming an official sponsor.

Open Source Features
========

Helpy is an integrated support solution- combining and leveraging synergies between support ticketing, Knowledgebase and a public community.  Each feature is optional however, and can be easily disabled.

- **Multichannel ticketing:** Integrated with inbound email via Sendgrid, Mandrill, Mailgun, etc.
- **Knowledgebase:** Full text searchable and SEO optimized to help users answer questions before they contact you.
- **Pre-wired for Google Analytics:**  Using a combination of JS and Measurement Protocol tags, Helpy is prewired to track everything from article satisfaction to what your agents are doing.
- **Mobile-first:** Support requests come at all times, and Helpy works on all devices out of the box so you can delight customers with prompt answers, from anywhere and at anytime!
- **Community Support Forums:** Customers and Agents can both answer questions in a publicly accessible forum.
- **Voting**: Discussion topics and replies support voting.
- **Embed Widget:** Helpy Includes a lightweight javascript widget that allows your users to contact you from just about anywhere.
- **Multi-lingual:** Helpy is fully multi-lingual and can provide support in multiple languages at the same time.  Currently the app includes translations for 19 languages and is easy to translate.
- **Themeable:** Customize the look and functionality of your Helpy without disturbing the underlying system that makes it all work. Helpy comes with two additional themes, and we hope to add more and get more from the community as time goes on.

What is new in Version 2.0
=========
Version 2 includes a number of awesome improvements in the open source edition, and even more in the pro and cloud hosted versions:

- Refreshed Admin UI
- New Helpcenter theme: Singular
- HTML support when responding to tickets
- Nicer HTML alert emails
- Nicer HTML responses to customers
- HTML emails now include the full ticket history
- UI for replying to tickets re-imagined
- Inline customer editing
- Channel and source reporting
- New support for emoji's in ticket replies
- Customize the colors of the admin UI
- Ability to email customers from the create ticket dialogue
- New internal ticket type
- Set all ticket params from admin create ticket UI
- Font Awesome 5 iconography
- Improved support for CC and BCC recipients
- Import/Export data in CSV
- Comply with GDPR by deleting or anonymizing users

Cloud Version
=========

We also offer a hosted version with additional features designed to make your helpcenter even more awesome. This is a turn-key SaaS and does not require any effort on your part to get it up and running. Proceeds go directly towards supporting the continued development of the project. Some of the things found in the hosted version:

- Triggers: Insert events at any point in the ticket lifecycle. This includes an outbound JSON API.
- Notifications: Browser notifications when new tickets are received, you are assigned to a ticket, etc.
- Real time UI: When tickets arrive, they are automatically added to the UI
- Custom Views: Add additional Ticketing queues to highlight just the tickets you need to see
- Advanced reporting: A suite of additional reports on the performance of your ticketing and helpcenter knowledgebase
- Advanced search: Easily filter and find tickets or customers when you have thousands
- Customizable Request Forms: Easily Add questions to the ticket creation forms
- AI Support Chatbot: Create a chatbot for your website to answer up 90% of tier one questions autonomously

On-Premise and Dedicated Cloud
=========

You may prefer to run Helpy locally or in-country.  You can still get access to the full cloud feature set with either an on-premise installation of the cloud hosted features, or a dedicated AWS instance in a regional data-center.  

Live Demo
=========

There is also a live demo with fake data available at [http://demo.helpy.io](http://demo.helpy.io)
Admin User: `admin@test.com` and password: `12345678`

Installation
============

Helpy was designed to run on on modern cloud providers, although it should work on
any linux based system.  There is a full guide to installing Helpy in the wiki: https://github.com/helpyio/helpy/wiki

Requirements are:

- Ruby 2.2+
- Rails 4.2.x
- Postgres
- A server like Unicorn, Puma or Passenger

Helpy leverages two external services to help out:

- an email provider like Sendgrid
- Google Analytics for stats (optional)


Getting Started:
----------------

**Install Helpy on your Local System**

Although not required, installing locally is highly recommended and will make it easier for you to customize things like settings, colors and logos to match your site identity.  To begin, clone Helpy from the official repo to your local system:

`git clone https://github.com/helpyio/helpy.git`

**Install Helpy via Docker**

Docker is the recommended way to quickly test or run Helpy in production.

1) Install [Docker](https://get.docker.com/) and docker-compose
2) Edit the `docker/.env` file with the neccessary information and passwords
3) Edit `docker/Caddyfile` to include your URL or turn on SSL
4) Run `docker-compose up -d` to start all of the services

_Other notes_
You can modify `docker/run.sh` and set `DO_NOT_PREPARE` to true, which will skip compiling the assets when the docker container loads. While this makes the container start faster, it is not reccommended because this is also the step where database migrations are run. If there's an update and the migrations don't run it could lead to issues with the website throwing a lot of errors.

**Configure Basic Settings**

There is a settings option in the admin panel to set up things like i18n, system names, colors, the embeddable widget, etc.  There is a full guide to getting set up at: [Configuring Your Helpy Settings](http://support.helpy.io/en/knowledgebase/11-Installing-Helpy/docs/22-Configuring-your-Helpy-Settings)

**Support Multiple Languages (optional)**

Helpy includes support for Multilingual help sites, and multi-language knowledgebase articles.  This page explains how to enable Helpy's international capabilities and provides an overview of what functionality this adds to Helpy: [How To Set Up A Multilingual Helpy Support Knowledgebase](http://support.helpy.io/en/knowledgebase/12-Using-Helpy/docs/9-How-to-set-up-a-multilingual-Helpy-support-knowledgebase)

**Set up your Helpy to send and receive email (optional)**

Helpy has the ability to receive email at your support email addresses and import the messages as tickets in the web interface.  Whenever you or the user replies to the email thread, Helpy captures the discussion and sends out messages accordingly. Follow the tutorial on [Setting Up Your Helpy Installation To Send And Receive Email](http://support.helpy.io/en/knowledgebase/11-Installing-Helpy/docs/14-Setting-up-your-Helpy-installation-to-send-and-receive-email) to set this up.

**Configure oAuth (optional)**

Helpy supports Omniauth login capabilities.  This means you can allow your support users to sign in with a single click via any Omniauth provider- ie. Facebook, Twitter, Gmail, or many others. Read [Setting Up Oauth For Your Helpy](https://github.com/helpyio/helpy/wiki/Configuring-OAUTH) to see how.

Contributing
============

Welcome, and thanks for contributing to Helpy.  Together we are building the best customer support platform in the world.  Here are some of the ways you can contribute:

- Report or fix Bugs
- Refactoring
- Improve test coverage-  As with any large and growing codebase, test coverage is not always as good as it could be.  Help improving test coverage is always welcome and will help you learn how Helpy works.  We use Minitest exclusively.
- Translate the project- The community has already translated Helpy into 18 languages, but there are many more waiting.  We need help getting Helpy translated into as many locales as possible! [Please see the guide to translation](https://github.com/helpyio/helpy/wiki/How-to-translate-Helpy-into-your-language) for more details.
- Build new features.  There is a backlog of new features that we’d like to see built.  Check out our [roadmap](https://trello.com/b/NuiWsdmK/helpy) for more insight on this, and if you would like to take one on, please get in touch with us to make sure someone is not already working on it.

**General Guidelines:**

- Join us on Slack.  Let me know you wish to contribute. [![Slack Status](https://helpyioslackin.herokuapp.com/badge.svg)](https://helpyioslackin.herokuapp.com)
- Make your PRs granular.  They should only include one piece of functionality per PR.
- Check the roadmap: [Trello](https://trello.com/b/NuiWsdmK/helpy) If you want to build a feature, contact us to make sure no one else is already working on it
- You must provide passing test coverage.  We use minitest, see http://www.rubypigeon.com/posts/minitest-cheat-sheet/?utm_source=rubyweekly&utm_medium=email
- You also must expose functionality to the API.  We use Grape.  API methods should be tested as well.
- If your feature/bug fix/enhancement adds or changes text in the project, please create i18n strings in `en.yml` and any other locales you can.
- We are hugely concerned with user experience, and a nice UI.  Oftentimes that means we may take what you have contributed and “dress it up” or ask you to do the same.

License
=======

Copyright 2016-2018, Helpy.io, LLC, Scott Miller and Contributors. Helpy is released under the MIT open source license.  Please contribute back any enhancements you make.  Also, I would appreciate if you kept the "powered by Helpy" blurb in the footer.  This helps me keep track of how many are using Helpy.

[![Analytics](https://ga-beacon.appspot.com/UA-50151-28/helpy/readme?pixel)](https://github.com/igrigorik/ga-beacon)
