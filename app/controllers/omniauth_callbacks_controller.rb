class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :verify_authenticity_token

  def github
    handle_redirect('devise.github_uid', 'Github')
  end

  def twitter
    handle_redirect('devise.twitter_uid', 'Twitter')
  end

  def google_oauth2
    handle_redirect('devise.google_uid', 'Google')
  end

  private

  def handle_redirect(_session_variable, _kind)

    # Use the session locale set earlier; use the default if it isn't available.
    I18n.locale = session[:omniauth_login_locale] || I18n.default_locale

    # NOTE: This is for oauth users without email addresses.  This means twitter
    # and sometimes github and facebook.  They are redirected to add
    # their email address and then returned to the home page

    @user = user
    if !env['omniauth.auth'].email.present? && @user.email == @user.temp_email(env['omniauth.auth'])
      # @user = user
      session['omniauth_uid'] = env['omniauth.auth'].uid

      @page_title = "Please complete your signup"
      # render "users/finish_signup"
      redirect_to finish_signup_path
    else
      sign_in_and_redirect user#, event: :authentication
    end
  end

  def user
    User.find_for_oauth(env['omniauth.auth'])
  end


end
