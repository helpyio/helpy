class Admin::OnboardingController < Admin::BaseController

  layout 'onboarding'

  def update_user

    if current_user.admin?
      @user = User.find(params[:id])
      @user.admin = params[:user][:admin]
      @user.active = params[:user][:active]
      @user.password = params[:user][:password]
    else
      @user = current_user
    end

    @user.update(user_params)

    if current_user.admin?
      fetch_counts
      @topics = @user.topics.page params[:page]
      @tracker.event(category: "Agent: #{current_user.name}", action: "Edited User Profile", label: @user.name)
    end

    respond_to do |format|
      if @user.save
        logger.info("User saved")
        sign_in(@user, bypass: true) if current_user.admin? && params[:source] == 'ob'

        format.html {
          logger.info("redirecting home")
          redirect_to root_path
        }
        format.js {
          if params[:source] == 'ob'
            logger.info("render js")
            render js: "Helpy.showPanel(4);"
          else
            render 'admin/tickets' if current_user.admin?
          end
        }
      else
        format.html {
           render 'admin/onboarding', layout: 'onboard'
        }
        logger.info("Errors prevented saving the user")
      end
    end
  end

  def update_settings

    # NOTE: We iterate through settings here to establish our universe of settings to save
    # this means if you add a setting ie. in a plugin, you MUST declare a default value in the
    # "default_settings intializer".
    @settings = AppSettings.get_all

    # iterate through
    @settings.each do |setting|
      AppSettings[setting[0]] = params[setting[0].to_sym] unless params[setting[0].to_sym].nil?
    end

    respond_to do |format|
      format.html { redirect_to(admin_settings_path) }
      format.js {
        if params[:source] == 'ob'
          @ob = true
          render js: "Helpy.showPanel(3);$('#edit_user_1').enableClientSideValidations();"
        end
      }
    end
  end

  def onboarding
    @user = current_user
    @user.name = ""
    @user.email = ""
    @user.password = ""
    render layout: 'onboard'
  end

  def complete_onboard
    # Toggle setting for onboarding shown
    # AppSettings['onboard.shown'] = 'true'

    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {
        render js: "parent.$('#modal').modal('toggle');"
      }
    end
  end


end
