AppSettings.defaults['settings.parent_site'] = Settings.parent_site
AppSettings.defaults['settings.parent_company'] = Settings.parent_company
AppSettings.defaults['settings.site_url'] = Settings.site_url
AppSettings.defaults['settings.site_name'] = Settings.site_name
AppSettings.defaults['settings.site_tagline'] = Settings.site_tagline
AppSettings.defaults['settings.product_name'] = Settings.product_name
AppSettings.defaults['settings.support_phone'] = Settings.support_phone
AppSettings.defaults['settings.google_analytics_id'] = Settings.google_analytics_id
AppSettings.defaults['logos.favicon'] = Settings.app_favicon
AppSettings.defaults['logos.header_logo'] = Settings.app_mini_logo #Note: the contributer accidentally reversed these in the code
AppSettings.defaults['logos.footer_mini_logo'] = Settings.app_large_logo
AppSettings.defaults['i18n.default_locale'] = 'en'
AppSettings.defaults['i18n.available_locales'] = ''.split(',')
AppSettings.defaults['hidden.helptext'] = {
  site_name: "The name of the site you are supporting",
  parent_site: "The owner of this support site"
}
