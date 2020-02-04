class Admin::SettingsController < Admin::BaseController

  before_action :verify_admin, except: ['profile']
  #before_action :verify_agent, only: ['index']
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

  def update_general
    update_params = params.keys.select { |key| key.to_s.match('settings.') }
    update_params += params.keys.select { |key| key.to_s.match('branding.') }
    settings_update(update_params)

    # prevent null value for colors
    AppSettings["branding.ticketing_color"] = "#245566" if params["branding.ticketing_color"].blank?
    AppSettings["branding.ticketing_bg_color"] = "#f6f7e8" if params["branding.ticketing_bg_color"].blank?

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_general_settings_path
  end

  def update_design
    update_params = params.keys.select { |key| key.to_s.match('design.') }
    update_params += params.keys.select { |key| key.to_s.match('css.') }
    update_params -= ['uploader.design.header_logo','uploader.design.favicon']

    settings_update(update_params)
    @logo = Logo.new
    @logo.file = params['uploader.design.header_logo']
    @logo.save

    @thumb = Logo.new
    @thumb.file = params['uploader.design.favicon']
    @thumb.save

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_design_settings_path
  end

  def update_theme
    update_params = params.keys.select { |key| key.to_s.match('theme.') }
    settings_update(update_params)

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_theme_settings_path
  end

  def update_integration
    update_params = params.keys.select { |key| key.to_s.match('settings.') }
    update_params += params.keys.select { |key| key.to_s.match('cloudinary.') }
    update_params += params.keys.select { |key| key.to_s.match('webhook.') }
    settings_update(update_params)

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_integration_settings_path
  end

  def update_widget
    update_params = params.keys.select { |key| key.to_s.match('widget.') }
    settings_update(update_params)

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_widget_settings_path
  end

  def update_i18n
    update_params = params.keys.select { |key| key.to_s.match('i18n.') }
    settings_update(update_params)

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")
    redirect_to admin_i18n_settings_path
  end

  def update_email
    update_params = params.keys.select { |key| key.to_s.match('email.') }
    settings_update(update_params)

    flash[:success] = t(:settings_changes_saved,
                        site_url: AppSettings['settings.site_url'],
                        default: "The changes you have been saved.  Some changes are only visible on your helpcenter site: #{AppSettings['settings.site_url']}")

    TestMailer.new_test(current_user.email).deliver_later if params[:send_test] == "1"
    redirect_to admin_email_settings_path
  end

  def settings_update(update_params)
    update_params.each do |setting|
      AppSettings[setting] = params[setting]
    end
  end

  # NOTE Update settings is deprecated and is left here only if plugins or extensions
  # rely on it
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

    case params[:return_to]
    when "design"
      url = admin_design_settings_path
    when "general"
      url = admin_general_settings_path
    when "email"
      url = admin_email_settings_path
    when "theme"
      url = admin_theme_settings_path
    when "i18n"
      url = admin_i18n_settings_path
    when "integration"
      url = admin_integration_settings_path
    when "widget"
      url = admin_widget_settings_path
    else
      url = admin_general_settings_path
    end

    respond_to do |format|
      format.html {
        redirect_to url
      }
      format.js {
      }
    end
  end

end
