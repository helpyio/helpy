# Add Chat to your Helpy with Olark

This extension adds a webhook endpoint for receiving chat transcripts from Olark. When
a transcript is received, it it `POST`ed to your Helpy and created as a ticket.  It will
also be associated with the user, provided they use the same email address. If the
user is not found, they will be created inside of Helpy.

## Installation

Add this to your Gemfile:

```
gem 'helpy_onboarding', git: 'http://github.com/scott/helpy_onboarding', branch: 'master'
```

and then run:

```
bundle install
```

You will need an account with Olark for this extension to work.  Enabling the
integration requires that you add a special URL from Helpy to your Olark settings.
Follow these instructions to do that:

1. In Helpy, visit the settings, integrations panel and find the section for Olark.
You will see a special webhook URL for Olark here, which you should copy and paste
into Olark's settings:  

2. Next, go into your Olark account and create a new webhook integration in their
settings.  Paste the Helpy url into the space provided.

3. Make sure the integration is turned on in Helpy!
