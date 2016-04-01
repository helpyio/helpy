AppSettings.defaults['settings.parent_site'] = Settings.parent_site
AppSettings.defaults['settings.parent_company'] = Settings.parent_company
#AppSettings.defaults[:site_url] = Settings.site_url
AppSettings.defaults['settings.site_name'] = Settings.site_name
AppSettings.defaults['settings.site_tagline'] = Settings.site_tagline
AppSettings.defaults['settings.product_name'] = Settings.product_name
AppSettings.defaults['settings.support_phone'] = Settings.support_phone
AppSettings.defaults['logos.app_favicon'] = Settings.app_favicon
AppSettings.defaults['logos.app_large_logo'] = Settings.app_large_logo
AppSettings.defaults['logos.app_mini_logo'] = Settings.app_mini_logo
AppSettings.defaults['hidden.i18n'] = 'de,en,fr'.split(',')
AppSettings.defaults['hidden.helptext'] = {
  site_name: "The name of the site you are supporting",
  parent_site: "The owner of this support site"
}
