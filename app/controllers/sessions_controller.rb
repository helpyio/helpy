class SessionsController < Devise::SessionsController

  theme :theme_chosen

  def destroy
    # Preserve the saml_uid in the session
    if session.key?('saml_uid') && session["saml_uid"]
        saml_uid = session["saml_uid"]
        super do
            session["saml_uid"] = saml_uid
        end
    end
  end

  def after_sign_out_path_for(_)
    if session.key?('saml_uid') && session["saml_uid"]
      session.delete("saml_uid")
      user_saml_omniauth_authorize_path + "/spslo"
    else
      super
    end
  end
end
