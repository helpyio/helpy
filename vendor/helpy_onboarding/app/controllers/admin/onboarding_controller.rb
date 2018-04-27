class Admin::OnboardingController < Admin::BaseController

  layout 'onboard'
  before_action :allow_onboarding, except: 'complete'

  def index
    @user = current_user
    @user.name = ""
    @user.email = ""
    @user.password = ""
    render layout: 'onboard'
  end

  def update_user
    if current_user.admin?
      @user = User.find(params[:id])
      @user.admin = true
      @user.active = true
      @user.role = 'admin'
      @user.password = params[:user][:password]
    else
      @user = current_user
    end

    @user.update(user_params)
    if @user.save
      sign_in(@user, bypass: true) if current_user.admin?
      redirect_to admin_complete_onboard_path
    else
      logger.warn("Errors prevented saving the user")
      render :index
    end
  end

  def update_settings

    # NOTE: We iterate through settings here to establish our universe of settings to save
    # this means if you add a setting ie. in a plugin, you MUST declare a default value in the
    # "default_settings intializer".
    @settings = AppSettings.get_all

    # iterate through all settings.  We don't really need to do this for the
    # current version of onboarding, but this was kept in for future use if
    # we want to onboard more settings
    @settings.each do |setting|
      AppSettings[setting[0]] = params[setting[0].to_sym] unless params[setting[0].to_sym].nil?
    end

    respond_to do |format|
      format.html { redirect_to(admin_settings_path) }
      format.js {
          render js: "Helpy.showPanel(3);$('#edit_user_1').enableClientSideValidations();"
      }
    end
  end

  def complete
    respond_to :html
  end

  protected

  def allow_onboarding
    unless show_onboarding?
      redirect_to admin_complete_onboard_path
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :company
    )
  end



end
