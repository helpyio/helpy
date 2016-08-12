require 'test_helper'

class Admin::OnboardingControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  # Browsers should be prevented from accessing onboarding
  test "a browser should not be able to view the onboarding process" do
    get :index, locale: :en
    assert_redirected_to '/en/users/sign_in'
  end

  # Admin tests
  test "a new admin should be able to view the onboarding process" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

  test "an admin with a changed email should not be able to view the onboarding process" do
    sign_in users(:another_admin)
    get :index
    assert_redirected_to admin_complete_onboard_path
  end

  test "a new admin should be able to update the name and domain of their helpy" do
    sign_in users(:admin)

    xhr :patch, :update_settings,
      'settings.site_name' => 'Helpy Support 2',
      'settings.site_url' => 'http://support.site.com',
      'settings.parent_site' => 'http://helpy.io/2',
      'settings.parent_company' => 'Helpy 2'

    assert_response :success
    assert_equal 'Helpy Support 2', AppSettings['settings.site_name']
    assert_equal 'http://support.site.com', AppSettings['settings.site_url']
    assert_equal 'http://helpy.io/2', AppSettings['settings.parent_site']
    assert_equal 'Helpy 2', AppSettings['settings.parent_company']
  end

  test "a new admin should be able to update their email and password" do
    sign_in users(:admin)

    patch :update_user, {
      id: 1,
      user: {
        name: "something",
        email: "something@test.com",
        company: "company",
        password: "12345678" }
    }

    user = User.find(1)
    assert user.name == "something", "name does not update"
    assert user.email == "something@test.com", "email does not update"
    assert user.company == "company", "company does not update"
  end



end
