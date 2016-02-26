class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :verify_authenticity_token

  def github
    handle_redirect('devise.github_uid', 'Github')
  end

  def twitter
    handle_redirect('devise.twitter_uid', 'Twitter')
  end

  def google
    handle_redirect('devise.google_uid', 'Google')
  end

  private

  def handle_redirect(_session_variable, _kind)
    # Use the session locale set earlier; use the default if it isn't available.
    I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
    sign_in_and_redirect user#, event: :authentication
  end

  def user
    User.find_for_oauth(env['omniauth.auth'])
  end


end
