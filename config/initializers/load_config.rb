APP_CONFIG = YAML.load_file("#{::Rails.root}/config/settings.yml")[::Rails.env].symbolize_keys
