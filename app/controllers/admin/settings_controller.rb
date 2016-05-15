class Admin::SettingsController < Admin::BaseController

  respond_to :html, :js
  before_action :settings_mode

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
    # @ob = true if params[:source] == 'ob'
    # respond_to do |format|
    #   format.html { redirect_to(admin_settings_path) }
    #   format.js {
    #     if params[:source] == 'ob'
    #       render js: "Helpy.showPanel(3);$('#edit_user_1').enableClientSideValidations();"
    #     end
    #   }
    # end
  end

  protected

  def settings_mode
    @mode = 'ob' if params[:settings_mode] == 'ob'
  end

end
