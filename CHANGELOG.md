## VERSION 2.4

Version 2.4 is packed with some great new stuff to make your Helpy experience better than ever.  It also includes some important security updates
to the underlying software running Helpy and its recommended your update as soon as possible.

Security Updates:

- Rails has been updated to 4.2.11.1
- Devise has been updated to 4.6.1
- Many other dependencies have been updated

New features, improvements and fixes:
- New: tag manager for controlling tags through the admin settings.
- New: Tag picker on the agent ticket view
- New: Quick KB search when creating or responding to tickets to add links to articles
- New: Autosave for ticket replies and knowledgebase article editor
- New: A number of new settings have been added to customize how Helpy works.
- Fixed: support email addresses are now removed from the CC field automatically
- Fixed: Flash wrapper width reduced @cr0vy
- Fixed: Widget mixed content issue with Google Fonts @karser
- Optimizations: A number of optimizations have been made to improve performance
- Update: Email parsing has been improved, particularly for non English email
- Update: Onboarding has been moved to the unlogged-in state.  This only affects new installs
- Docker: Uploads folder made writable @sarke

## VERSION 2.3

This release includes a new theme contributed by the team at Seravo called "Nordic" (thanks @ottok, @elguitar, @simoke, @tlxo and anyone else I missed), along with a number of dependency updates, bug fixes, and improvements to the docker container.  In addition ENV vars were added for remote file storage and database as a service (docker only) that should make it easier to work with Elastic Beanstalk/Kubernetes.

Full list of improvements and fixes:
- Dependency updates
- Fix a bug which disabled validations for associated fields
- Prevent a 500 when a topic is missing a user_id (direct result of missing validation above)
- Resolved a lot of intermittent tests
- New theme: Nordic
- Enable clicking outside keyboard shortcuts modal to close
- Conditional support for S3 compatible remote filestore using fog gem
- Updates to Docker container from @ypcs and adds 


## VERSION 2.2

This release includes fixes to several serious vulnerabilities including:

[CVE-2018-18886](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-18886).  This fixes a serious XSS vulnerability (Reported by @joanbono). This was fixed in the master branch several weeks ago, but if you are running a prior version, including 1.x releases, you should upgrade to `2.2.0` as soon as possible.

Upgrades Rails to 4.2.11.  This includes a fix to a significant security vulnerability in ActiveJob.

Other improvements in this release include:

- Bring dependencies up to date
- Improved support for forwarded emails
- Accept emails from users who use a number in the first part of their email or configured email name
- Correctly handle emails with no subject
- Add support for IMAP email
- Prevent agents from accessing API
- Harden agents ability to edit administrators
- Rename Login to Sign in
- Allow new users when admin creating an internal note


## VERSION 2.1

This release builds on the awesomeness of version 2 by adding several new enhancements-

- Editable header and footer for html ticket email to customers.
- support for merge tokens (%customer_name% and %customer_email%) with more coming soon. 
- Ability to create a ticket with a note as the first post (useful for calls, walk ins, etc)
- Refactor of settings backend and addition of ability to test smtp settings
- Restrict API access from agents

Upgrading:

Make sure you run `bundle exec rake db:migrate` and also `bundle exec rake update:enable_templates` to turn on the templates feature.

## VERSION 2.0

Version 2 includes a number of awesome improvements, listed below. This should be a fairly straightforward update for most people, make sure you:

`bundle install`
`bundle exec rake db:migrate`

We have a live demo at https://demo.helpy.io/  The admin username is "admin@test.com" and admin password is "12345678"

Updated/New Features:

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