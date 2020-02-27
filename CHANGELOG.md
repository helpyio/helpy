## VERSION 2.8.0

Version 2.8 contains important security updates and the following new featuers:

- NEW It is now possible create users one at a time, with or without inviting them.
- NEW When creating tickets by API, you can now specify the CC and BCC for the new ticket.
- NEW A new API for viewing and editing taggings has been added (thanks @schmidt)
- NEW A honeypot (anti spam) feature was added to the new ticket form (thanks @schmidt)
- CHANGE Assigning an agent no longer automatically marks the ticket as "pending".
- CHANGE The whitelist of allowable file attachments has been significantly changed and made more flexible (see upgrade notes below).
- FIX A bug was fixed that displays the proper error message when a non supported file attachment is made in the web UI
- FIX #1576 The right menu no longer gets stuck open when turbolinks is enabled
- FIX #1581 Radio buttons are now properly aligned in the mobile responsive view of the Singular theme

IMPORTANT UPGRADE NOTES:

This release of Helpy includes a change to the way file attachments are handled.  Previous
versions used a default "whitelist" of file types where were allowed and was generally limited to
the most common image and doc foramts.

This version adds configuration settings which can be modified by API that allow you to set your own
whitelist of filetypes which should be allowed, or a blacklist of filetypes that should be rejected.  In
addition, the default whitelist has been removed, and Helpy now ships with a short blacklist of files that could be 
considered "risky."  Files with these extensions are blacklisted by default:

```
ade, adp, apk, appx, appxbundle, bat, cab, chm, cmd, com, cpl, dll, dmg, exe, hta, ins, isp, iso, jar, js, jse, lib, 
lnk, mde, msc, msi, msix, msixbundle, msp, mst, nsh, pif, ps1, scr, sct, .shb, sys, vb, vbe, vbs, vxd, wsc, wsf, wsh
```

NOTE:  Do not provide values for both blacklist and whitelist, as they will conflict and it will be impossible for
customers to attach files.


## VERSION 2.7.0

The 2.7 release of Helpy is here, with several great new features to help you better provide great customer support.

New Features:

- New nested categories feature lets you create sub categories with a drag and drop UI to group and administer them.
- New API setting for default reply type
- Site URL is now validated
- New Anti-spam setting to filter any ticket from matching email addresses to spam
- Address a ticket is sent to is now captured

Bug Fixes:

- Webhooks preference did not always save
- Customers list view does not always load

See UPDATING.md for details on how to update.

## VERSION 2.6.0

This release fixes several edge case bugs and adds a couple new API features and an all new Ukrainian language translation.  Specifically:

- New Ukrainian locale #1378 @Serg2294 

Bug Fixes:

- Translated versions are now properly included in the search index #1375 
- The CC address is now persisted if you change the assignment of a ticket while editing the reply #1387
- Agents can now create an unassigned ticket #1317
- A rare bug that docs unclickable on mobile has been resolved #1371 

API:

- A new endpoint has been added to get specifics of the currently logged in user #1242 @trevormerritt 
- Categories can now be filtered by visibility (public/private/internal) #1269
- Forum topics now respect a limit param #1357 @elguitar 
- The User entity is now included with topics and posts #1318 

Misc:

- Can now specify a theme environment var when running test suite #1253 @azul 


## VERSION 2.5.0

This release adds important new functionality for managing incoming spam email tickets (particularly from parse webhook services such as Sendgrid or Mandrill). 
Two new settings have been added that use the spam assassin score provided by these providers to either block tickets outright, or filter them to the spam
folder. In addition, dependencies have been upgraded.

- Expose trash and Spam tickets navigation in the left ticketing nav
- Adds two settings to adjust how Helpy filters spam (when using Sendgrid, Mandrill, etc.)
- Stores the spam score of incoming emails in the Topic table
- Adds the ability to do bulk actions on *all* tickets matching a search
- Adds the option to "empty the trash", permanently deleting all messages in the trash

See UPDATING.md for details on how to update.

## VERSION 2.4.3

This release fixes a bug in the way autosaving was handled. 

- Autosave functionality improved
- Added a button to clear autosaved draft if present
- Removed autosave from KB editor
- Depenedencies updated

## VERSION 2.4.2

This release updates dependecies and fixes an issue with the docker container which prevented it from booting.

- Dependencies updated
- Critical security update for Nokogiri
- Fixed: Docker container would not boot

## VERSION 2.4.1

This release fixes a couple thing from the last release, in addition to updating some dependencies. Specifically:

- Resetting passwords works again- this was a regression with the update of Devise
- Tags are now shown in alphabetical order- helpful if you have a large number
- Tag management is now paginated- again helpful if you have a large number

Also

- Some additional navigation was added into the knowledgebase editor

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