class RegistrationsController < Devise::RegistrationsController

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
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
#    unless current_user.provider.nil?
      params.require(:user).permit(:name, :email, :bio, :avatar, :company, :title, :password, :password_confirmation, :current_password)
#    else
#      params.require(:user).permit(:name, :email, :bio, :avatar, :company, :title)
#    end
  end

end
