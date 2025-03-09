require 'test_helper'

class OnboardingControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    AppSettings['onboarding.complete'] = '0'
  end

  # Admin tests
  test "a new admin should be able to view the onboarding process" do
    get :index, params: { locale: "en" }
    assert_response :success
  end

  test "an admin who has already completed the onboard should not see the onboard process" do
    AppSettings['onboarding.complete'] = '1'
    get :index, params: {}
    assert_redirected_to complete_onboard_path
  end

  test "a new admin should be able to update the name and domain of their helpy" do

    patch :update_settings, params: {
      'settings.site_name' => 'Helpy Support 2',
      'settings.site_url' => 'http://support.site.com',
      'settings.parent_site' => 'http://helpy.io/2',
      'settings.parent_company' => 'Helpy 2'
    }, xhr: true
    assert_response :success
    assert_equal 'Helpy Support 2', AppSettings['settings.site_name']
    assert_equal 'http://support.site.com', AppSettings['settings.site_url']
    assert_equal 'http://helpy.io/2', AppSettings['settings.parent_site']
    assert_equal 'Helpy 2', AppSettings['settings.parent_company']
  end

  test "a new admin should be able to update their email and password" do
    patch :update_user, params: {
      user: {
        name: "something",
        email: "something@test.com",
        company: "company",
        password: "12345678" }
    }, xhr: true

    user = User.find(1)
    assert user.name == "something", "name does not update"
    assert user.email == "something@test.com", "email does not update"
    assert user.company == "company", "company does not update"
  end



end
