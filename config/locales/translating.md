# How to contribute a locale

Thank you for helping us translate Helpy!  Without your support, it would be impossible to build an amazing global support system.  Follow the guidelines here to complete your translations.

### Adding a Brand New locale

Adding a locale file should be fairly straightforward if you have done any internationalization or localization in Rails.  But for those that have not, or need a refresher- here is how to get started.  This tutorial assumes you have a basic knowledge of Git.  You can either fork the project and add your translations then send a pull request, or copy and paste them into a gist and create a ticket to let me know.

1. First Steps: Rails uses a yaml file for each language (or locale.)  You will need to create a new yaml file for your language.  To do this, locate the en.yml file in the application structure: `/config/locales/en.yml`

2. Create your `.yml` file:  Make a copy of this file and rename it using the locale-language code that matches the target language you are translating to.  Yaml files provide a structured key value representation.  If you were creating a translation for Italian, name it: `it.yml`

3. Translate! Go line by then through the file and translate each value from English to your target language.  If you want to see how the translation is used on site, refer to the commenting which gives the approximate use for each translation.  You should also add your name to the translator(s) line :)  You generally will not need to worry about files in the `devise`, `devise_invitable`, `languages`, or `oauth` folders unless your locale is missing.

Example from en.yml before translating:

```
en:
  language_name: 'English' # The name of the translation file, in that language
  root: &root 'Home'
  how_can_we_help: "How can we help?"
  browse_topics: "Browse Topics"
  support_team: "Support Team"
  nothing_here: "Nothing here yet!"
```

Example after:

```
de:
  language_name: 'Deutsch' # The name of the translation file, in that language
  root: &root 'Home'
  how_can_we_help: "Wie können wir Ihnen helfen?"
  browse_topics: "Themen durchsuchen"
  support_team: "Support Team"
  nothing_here: "Noch nichts hier!"
```

4. Submit your translation: How you submit your new translations depends on whether you forked the project or not.  If you forked, go ahead and commit your changes, push to GitHub and create a pull request.  The other option is to use http://gist.github.com and cut and paste your file into a gist and then submit it (create a ticket, email, twitter etc.)

### Maintaining or bringing and existing locale up to date

Because Helpy is constantly adding new features, it is common for the `.yml` files to be missing a few strings.  You can help us with this by syncing the files with the current `en.yml` and adding strings or correcting typos.  If you think you have a better translation than what we currently use, by all means submit.  In some cases the translated strings are taken from Google Translate.

1. Getting Started:  To update an existing locale, you will probably want to use an editor that supports split window view, so you can have the current `en.yml` file open on one side, and your target locale open on the other.  

2. Update and Translate: Next go line by line and look for strings that are missing from your target locale.  In some cases they will already be present but will not be translated and will be commented out to indicate that they need translation.  Make your changes, and then be sure to add your name to the list of translators in the comment at the top of the page.

3. Submit your translation: How you submit your new translations depends on whether you forked the project or not.  If you forked, go ahead and commit your changes, push to GitHub and create a pull request.  The other option is to use http://gist.github.com and cut and paste your file into a gist and then submit it (create a ticket, email, twitter etc.)

### A note about getting your new translation file to work

Helpy integrates with Rails I18n so that administrators can select locales from a web based form.  As a translator it is not entirely intuitive how to get your locale file to work.  To start with, add the locale to production.rb or development.rb on the following line:

```
config.i18n.available_locales = [:en, :es, :de, :fr, :et, :ca, :ru, :ja, :hi, 'zh-cn', 'zh-tw', 'pt', :nl, 'tr', 'pt-br', :fa]
```

Restart your server, and now use your browser to go to the admin panel, settings and international.  You will see all of the available locales listed, including the one you just added.  Check the box next to each locale you wish to enable.
