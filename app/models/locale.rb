class Locale
    def self.number_enabled
        AppSettings['i18n.available_locales'].size
    end

    def self.default
        AppSettings['i18n.default_locale']
    end

    # Set current locale to param or the default
    def self.current(user, param = Locale.default)

        # Prefer user locale to default 
        if user.present? && Locale.number_enabled > 1
            user.language
        elsif user.present? && Locale.number_enabled == 1 # use default if only one enabled
            Locale.default
        else 
            param
        end
    end
end