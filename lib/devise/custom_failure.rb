class CustomFailure < Devise::FailureApp
  def redirect_url
    I18n.locale = params[:locale] if params[:locale]
    new_user_session_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
