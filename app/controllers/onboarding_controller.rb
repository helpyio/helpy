class OnboardingController < ApplicationController

  layout 'onboard'
  before_action :allow_onboarding, except: 'complete'

  def index
    @user = User.first
    @user.name = ""
    @user.email = ""
    @user.password = ""
  end

  def update_user
    @user = User.first
    @user.admin = true
    @user.active = true
    @user.role = 'admin'
    @user.password = params[:user][:password]

    @user.update(user_params)

    if @user.save
      bypass_sign_in(@user) if @user.admin?
      respond_to do |format|
        format.js {
          render js: "Helpy.showPanel(3);$('#edit_user_1').enableClientSideValidations();"
        }
      end
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

    @logo = Logo.new
    @logo.file = params['uploader.design.header_logo']
    @logo.save

    @thumb = Logo.new
    @thumb.file = params['uploader.design.favicon']
    @thumb.save


    respond_to do |format|
      format.html { redirect_to(complete_onboard_path) }
      format.js {
          render js: "Helpy.showPanel(#{params[:nextpanel]});$('#edit_user_1').enableClientSideValidations();"
      }
    end
  end

  def complete
    AppSettings['onboarding.complete'] = '1'
    respond_to :html
  end

  protected

  def allow_onboarding
    unless show_onboarding?
      redirect_to complete_onboard_path
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
