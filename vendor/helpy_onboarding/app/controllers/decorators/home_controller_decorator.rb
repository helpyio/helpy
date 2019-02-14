HomeController.class_eval do
  before_action :show_onboard

  def show_onboard
    redirect_to onboarding_path if show_onboarding?
  end

end