class Admin::SettingsController < Admin::BaseController

  before_action :verify_admin, except: ['index', 'profile']
  before_action :verify_agent, only: ['index']
  skip_before_action :verify_authenticity_token

  def index
    @settings = AppSettings.get_all
    render layout: "admin"
  end

  def general
    render layout: 'admin-settings'
  end

  def design
    render layout: 'admin-settings'
  end

  def theme
    @themes = Theme.find_all
    render layout: 'admin-settings'
  end

  def widget
    render layout: 'admin-settings'
  end

  def i18n
    render layout: 'admin-settings'
  end

  def email
    render layout: 'admin-settings'
  end

  def integration
    # Set the webhook key if its blank
    AppSettings["webhook.form_key"] = SecureRandom.hex if AppSettings["webhook.form_key"].blank?
    render layout: 'admin-settings'
  end

  def profile
    @user = User.find(current_user.id)
    tracker("Agent: #{current_user.name}", "Editing User Profile", @user.name)
    render layout: 'admin-settings'
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
      AppSettings[setting[0]] = params[setting[0].to_sym] if params[setting[0].to_sym].present?
    end

    @logo = Logo.new
    @logo.file = params['uploader.design.header_logo']
    @logo.save

    @thumb = Logo.new
    @thumb.file = params['uploader.design.favicon']
    @thumb.save

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    respond_to do |format|
      format.html {
        redirect_to admin_settings_path
      }
      format.js {
      }
    end
  end


end
