# General Settings:

AppSettings.defaults["branding.ticketing_color"] = "#245566"
AppSettings.defaults["branding.ticketing_bg_color"] = "#f6f7e8"
AppSettings.defaults["branding.ticketing_bg_image"] = ""
AppSettings.defaults["branding.display_branding"] = "1"

AppSettings.defaults["settings.enforce_ssl"] = "0"
AppSettings.defaults["settings.parent_site"] = Settings.parent_site
AppSettings.defaults["settings.parent_company"] = Settings.parent_company
AppSettings.defaults["settings.site_url"] = Settings.site_url
AppSettings.defaults["settings.site_name"] = Settings.site_name
AppSettings.defaults["settings.site_tagline"] = Settings.site_tagline
AppSettings.defaults["settings.product_name"] = Settings.product_name
AppSettings.defaults["settings.support_phone"] = Settings.support_phone
AppSettings.defaults["settings.google_analytics_id"] = Settings.google_analytics_id
AppSettings.defaults["settings.google_analytics_enabled"] = '0'
AppSettings.defaults["settings.recaptcha_site_key"] = Settings.recaptcha_site_key
AppSettings.defaults["settings.recaptcha_api_key"] = Settings.recaptcha_api_key
AppSettings.defaults["settings.recaptcha_enabled"] = '0'
AppSettings.defaults["settings.forums"] = Settings.forums
AppSettings.defaults["settings.tickets"] = Settings.tickets
AppSettings.defaults["settings.knowledgebase"] = Settings.knowledgebase
AppSettings.defaults["settings.teams"] = Settings.teams
AppSettings.defaults["settings.welcome_email"] = Settings.welcome_email
AppSettings.defaults['settings.global_bcc'] = []
AppSettings.defaults['settings.default_channel'] = 'email'
AppSettings.defaults['settings.include_ticket_history'] = '1'
AppSettings.defaults['settings.include_ticket_body'] = '1'
AppSettings.defaults['settings.default_private'] = '0'
AppSettings.defaults['settings.anonymous_access'] = '0'
AppSettings.defaults['settings.anonymous_salt'] = 'salt'
AppSettings.defaults['settings.extension_whitelist'] = ''
AppSettings.defaults['settings.extension_blacklist'] = 'ade, adp, apk, appx, appxbundle, bat, cab, chm, cmd, com, cpl, dll, dmg, exe, hta, ins, isp, iso, jar, js, jse, lib, lnk, mde, msc, msi, msix, msixbundle, msp, mst, nsh, pif, ps1, scr, sct, .shb, sys, vb, vbe, vbs, vxd, wsc, wsf, wsh'

# Webhook Integrations

AppSettings.defaults["webhook.form_enabled"] = "0"
AppSettings.defaults["webhook.form_key"] = ""

# Design: (Colors etc.)

AppSettings.defaults["design.favicon"] = Settings.app_favicon
AppSettings.defaults["design.header_logo"] = Settings.app_mini_logo
# Note: the contributer accidentally reversed these in the code
AppSettings.defaults["design.footer_mini_logo"] = Settings.app_large_logo
AppSettings.defaults["design.css"] = ""
AppSettings.defaults["design.header_js"] = ""
AppSettings.defaults["design.footer_js"] = ""
AppSettings.defaults["css.search_background"] = ""
AppSettings.defaults["css.top_bar"] = ""
AppSettings.defaults["css.link_color"] = ""
AppSettings.defaults["css.form_background"] = ""
AppSettings.defaults["css.still_need_help"] = ""
AppSettings.defaults["css.main_color"] = ""
AppSettings.defaults["css.accent_color"] = ""
AppSettings.defaults["css.form_color"] = ""

# Theme:

AppSettings.defaults["theme.active"] = "singular"

# i18n:

AppSettings.defaults["i18n.default_locale"] = "en"
AppSettings.defaults["i18n.available_locales"] = ["en","es","fr","de","fi"]

# Widget:

AppSettings.defaults["widget.show_on_support_site"] = "true"
AppSettings.defaults["widget.show_on_support_site"] = "true"
AppSettings.defaults["widget.css_styles"] = "<script>/* Add custom styles here */</script>"
AppSettings.defaults["widget.background_color"] = ""
AppSettings.defaults["widget.button_color"] = ""
AppSettings.defaults["widget.button_text_color"] = ""

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
AppSettings.defaults["email.spam_assassin_reject"]= 4
AppSettings.defaults["email.spam_assassin_filter"]= 2
AppSettings.defaults["email.email_blacklist"] = ""

# notifications

AppSettings.defaults["notify.on_private"] = "1"
AppSettings.defaults["notify.on_public"] = "1"
AppSettings.defaults["notify.on_reply"] = "1"

# Cloudinary:

AppSettings.defaults['cloudinary.enabled'] = '0'
AppSettings.defaults['cloudinary.cloud_name'] = ''
AppSettings.defaults['cloudinary.api_key'] = ''
AppSettings.defaults['cloudinary.api_secret'] = ''
