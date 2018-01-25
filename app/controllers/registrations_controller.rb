class RegistrationsController < Devise::RegistrationsController
  theme :theme_chosen

  # prevents locale from getting carried over- see https://github.com/plataformatec/devise/issues/3569
  prepend_before_action :require_no_authentication, :only => [ :new, :create ]
  prepend_before_action :allow_params_authentication!, :only => :create
  prepend_before_action { request.env["devise.skip_timeout"] = true }
  prepend_before_action :set_locale

  # Overwrite update_resource to let users to update their user without giving their password
  def update_resource(resource, params)
    unless current_user.provider.nil?
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :profile_image
    )
  end

  def account_update_params
      params.require(:user).permit(
        :name,
        :email,
        :bio,
        :avatar,
        :company,
        :title,
        :password,
        :time_zone,
        :password_confirmation,
        :current_password,
        :profile_image
      )
  end

end
