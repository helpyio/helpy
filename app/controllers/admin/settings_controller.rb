class Admin::SettingsController < Admin::BaseController

  before_action :verify_admin
  respond_to :html

  def index
    @settings = AppSettings.get_all
  end

  def update_settings
    # NOTE: We iterate through settings here to establish our universe of settings to save
    # this means if you add a setting, you MUST declare a default value in the "default_settings intializer"
    @settings = AppSettings.get_all
    # iterate through
    @settings.each do |setting|
      AppSettings[setting[0]] = params[setting[0].to_sym]
    end
    redirect_to(admin_settings_path)
  end

end
