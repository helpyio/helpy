ApplicationController.class_eval do

  helper_method :show_onboarding?

  # Here we are just checking if the onboarding should be shown, based on the
  # current admin username.
  def show_onboarding?
    # AppSettings['onboarding.complete'] == '0'
    User.first.email == 'admin@test.com' && User.first.email == 'admin@test.com' && User.first.is_admin?
  end

end
