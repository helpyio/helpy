class Admin::SettingsController < Admin::BaseController

  before_action :verify_admin, except: ['index', 'notifications','update_notifications']
  before_action :verify_agent, only: ['index', 'notifications', 'update_notifications']
  skip_before_action :verify_authenticity_token

  def index
    @settings = AppSettings.get_all
    @themes = Theme.find_all
  end

  # Show notification settings for current agent/admin
  def notifications
  end

  # Save notification preference for current agent/admin
  def update_notifications
    current_user.settings.notify_on_private = params['notify_on_private']
    current_user.settings.notify_on_public = params['notify_on_public']
    current_user.settings.notify_on_reply = params['notify_on_reply']

    redirect_to admin_settings_path
  end

  def preview
    theme = Theme.find(params[:theme])
    send_file File.join(theme.path, theme.thumbnail),
            type: 'image/png', disposition: 'inline', stream: false
  end

  def update_settings
    # NOTE: We iterate through settings here to establish our universe of settings to save
    # this means if you add a setting, you MUST declare a default value in the "default_settings intializer"
    @settings = AppSettings.get_all
    # iterate through
    @settings.each do |setting|
      AppSettings[setting[0]] = params[setting[0].to_sym]
    end

    @logo = Logo.new
    @logo.file = params['uploader.design.header_logo']
    # binding.pry
    @logo.save

    respond_to do |format|
      format.html {
        redirect_to admin_settings_path
      }
      format.js {
      }
    end
  end


end
