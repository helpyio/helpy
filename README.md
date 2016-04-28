Helpy: A Modern Helpdesk Alternative
====================================

Helpy is a modern, "mobile first" helpdesk solution written in Ruby on Rails 4.2 and released under the MIT license.  The goal of Helpy is to provide an open source alternative to commercial helpdesk solutions like Zendesk or desk.com

[![Build Status](https://img.shields.io/travis/helpyio/helpy/master.svg)](https://travis-ci.org/helpyio/helpy) [![Code Climate](https://codeclimate.com/github/helpyio/helpy/badges/gpa.svg)](https://codeclimate.com/github/helpyio/helpy)

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
- **Embed Widget:** Helpy Includes a lightweight javascript widget that allows your users to contact you from just about anywhere.
- **Multi-lingual:** Helpy is fully multi-lingual and can provide support in multiple languages at the same time.  Currently the app includes translations for English, French, German, Spanish, Catalan, Portuguese, Nederlands, Chinese, Japanese, Russian and Estonian and is easy to translate.  Helpy provides tools for translating your support content and the multilingual support site feature means your customers will only see content translated into their own locale.


Live Demo
=========

Admin User: `admin@test.com` and password: `12345678`

Front End: http://demo.helpy.io/
Admin Panel: http://demo.helpy.io/admin


Installation
============

Helpy was designed to run on on modern cloud providers like Digital Ocean or Heroku, although it should work just about anywhere.  For a quick trial you can get set up on Heroku by clicking this button:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Requirements are:

- Ruby 2.2
- Rails 4.2
- Postgres
- A server like Unicorn, Puma or Passenger

Helpy leverages three external services to help out:

- an email provider like Mailgun
- an image manipulation and host (Cloudinary)
- Google Analytics for stats

Mailgun and Cloudinary have a free tier that should get you started.

There is a full guide to installing Helpy at http://support.helpy.io/en/knowledgebase/11-installing-helpy

Getting Started:
----------------

**Install Helpy on your Local System**

Although not required, installing locally is highly recommended and will make it easier for you to customize things like settings, colors and logos to match your site identity.  To begin, clone Helpy from the official repo to your local system:

`git clone https://github.com/helpyio/helpy.git`

**Configure Basic Settings**

There is a settings option in the admin panel to set up things like i18n, system names, colors, the embeddable widget, etc.  There is a full guide to getting set up at: [Configuring Your Helpy Settings](http://support.helpy.io/en/knowledgebase/11-Installing-Helpy/docs/22-Configuring-your-Helpy-Settings)

**Support Multiple Languages (optional)**

Helpy includes support for Multilingual help sites, and multi-language knowledgebase articles.  This page explains how to enable Helpy's international capabilities and provides an overview of what functionality this adds to Helpy: [How To Set Up A Multilingual Helpy Support Knowledgebase](http://support.helpy.io/en/knowledgebase/12-Using-Helpy/docs/9-How-to-set-up-a-multilingual-Helpy-support-knowledgebase)

**Set up your Helpy to send and receive email (optional)**

Helpy has the ability to receive email at your support email addresses and import the messages as tickets in the web interface.  Whenever you or the user replies to the email thread, Helpy captures the discussion and sends out messages accordingly. Follow the tutorial on [Setting Up Your Helpy Installation To Send And Receive Email](http://support.helpy.io/en/knowledgebase/11-Installing-Helpy/docs/14-Setting-up-your-Helpy-installation-to-send-and-receive-email) to set this up.

**Configure oAuth (optional)**

Helpy supports Omniauth login capabilities.  This means you can allow your support users to sign in with a single click via any Omniauth provider- ie. Facebook, Twitter, Gmail, or many others. Read [Setting Up Oauth For Your Helpy](http://support.helpy.io/en/knowledgebase/11-Installing-Helpy/docs/19-Setting-Up-OAUTH-for-your-Helpy) to see how.

**Set up Cloudinary (optional)**

Helpy uses a service called Cloudinary to host and manipulate images.  If you do not provide an API key in the admin settings, Helpy will not give users the option to attach images to their support tickets, and you will not be able to easily add images to your knowledge base documents.


Contributing
============

We have a contributors Slack room, please message me if you would like an invite.  There is also a project roadmap available at [Trello](https://trello.com/b/NuiWsdmK/helpy)

**Helpy needs your help speading the word.  The #1 contribution you could make is to blog, share, post, tweet, and tell people about Helpy.  This will go a long ways towards helping build a sustainable community.**

I am happy to accept contributions of any kind, including feedback and ideas, translations for other locales, and functionality. To submit translations, [please see the guide to translation](http://support.helpy.io/en/knowledgebase/12-Using-Helpy/docs/4-Supported-locales-How-to-Contribute) and send me a gist to your translation file.  For new functionality, follow the standard approach:

1. Fork the project
2. Create a Branch for your contribution
3. Write tests to cover your enhancements, and documentation describing what your feature is/does
4. Submit a pull request


License
=======

Copyright 2016, Scott Miller and Contributors. Helpy is released under the MIT open source license.  Please contribute back any enhancements you make.  Also, I would appreciate if you kept the "powered by Helpy" blurb in the footer.  This helps me keep track of how many are using Helpy.

[![Analytics](https://ga-beacon.appspot.com/UA-50151-28/helpy/readme?pixel)](https://github.com/igrigorik/ga-beacon)
