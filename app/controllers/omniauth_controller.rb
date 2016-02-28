class OmniauthController < ApplicationController

  def localized
    # Just save the current locale in the session and redirect to the unscoped path as before
    session[:omniauth_login_locale] = I18n.locale
    redirect_to user_omniauth_authorize_path(params[:provider])
  end

end
