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