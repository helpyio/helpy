class SessionsController < Devise::SessionsController
  theme :theme_chosen

  def create
    super do |resource|
      unless resource.active
        sign_out(resource)
        flash[:notice] = nil
        redirect_to root_path, alert: 'Your account is inactive.'
        return
      end
    end
  end
end
