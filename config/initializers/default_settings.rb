# General Settings:

AppSettings.defaults["settings.parent_site"] = Settings.parent_site
AppSettings.defaults["settings.parent_company"] = Settings.parent_company
AppSettings.defaults["settings.site_url"] = Settings.site_url
AppSettings.defaults["settings.site_name"] = Settings.site_name
AppSettings.defaults["settings.site_tagline"] = Settings.site_tagline
AppSettings.defaults["settings.product_name"] = Settings.product_name
AppSettings.defaults["settings.support_phone"] = Settings.support_phone
AppSettings.defaults["settings.google_analytics_id"] = Settings.google_analytics_id
AppSettings.defaults["settings.recaptcha_site_key"] = Settings.recaptcha_site_key
AppSettings.defaults["settings.recaptcha_api_key"] = Settings.recaptcha_api_key
AppSettings.defaults["settings.forums"] = Settings.forums
AppSettings.defaults["settings.tickets"] = Settings.tickets
AppSettings.defaults["settings.knowledgebase"] = Settings.knowledgebase
AppSettings.defaults["settings.teams"] = Settings.teams
AppSettings.defaults["settings.welcome_email"] = Settings.welcome_email
AppSettings.defaults["settings.allow_attachments"] = Settings.allow_attachments

# Design: (Colors etc.)

AppSettings.defaults["design.favicon"] = Settings.app_favicon
AppSettings.defaults["design.header_logo"] = Settings.app_mini_logo
# Note: the contributer accidentally reversed these in the code
AppSettings.defaults["design.footer_mini_logo"] = Settings.app_large_logo
AppSettings.defaults["design.css"] = ""
AppSettings.defaults["design.header_js"] = ""
AppSettings.defaults["design.footer_js"] = ""
AppSettings.defaults["css.search_background"] = "feffe9"
AppSettings.defaults["css.top_bar"] = "3cceff"
AppSettings.defaults["css.link_color"] = "004084"
AppSettings.defaults["css.form_background"] = "F0FFF0"
AppSettings.defaults["css.still_need_help"] = "ffdf91"
AppSettings.defaults["css.main_color"] = ""
AppSettings.defaults["css.accent_color"] = ""
AppSettings.defaults["css.form_color"] = ""

# Theme:

AppSettings.defaults["theme.active"] = "light"

# i18n:

AppSettings.defaults["i18n.default_locale"] = "en"
AppSettings.defaults["i18n.available_locales"] = ["en","es","fr","de"]

# Widget:

AppSettings.defaults["widget.show_on_support_site"] = "true"

# Email specific:

AppSettings.defaults["email.admin_email"] = Settings.admin_email
AppSettings.defaults["email.from_email"] = Settings.from_email
AppSettings.defaults["email.send_email"] = Settings.send_email

AppSettings.defaults["email.mail_service"] = Settings.mail_service
AppSettings.defaults["email.smtp_mail_username"] = Settings.smtp_mail_username
AppSettings.defaults["email.smtp_mail_password"] = Settings.smtp_mail_password
AppSettings.defaults["email.mail_smtp"] = Settings.mail_smtp
AppSettings.defaults["email.mail_port"] = Settings.mail_port
AppSettings.defaults["email.mail_domain"]= Settings.mail_domain

# notifications

AppSettings.defaults["notify.on_private"] = "1"
AppSettings.defaults["notify.on_public"] = "1"
AppSettings.defaults["notify.on_reply"] = "1"

# Cloudinary:

AppSettings.defaults['cloudinary.cloud_name'] = ''
AppSettings.defaults['cloudinary.api_key'] = ''
AppSettings.defaults['cloudinary.api_secret'] = ''
