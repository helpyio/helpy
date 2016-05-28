require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a browsing user should not be able to load the finish_signup page" do
    get :finish_signup, id: 3, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a signed in user should not be able to load the finish_signup page for another user" do
    sign_in users(:user)
    get :finish_signup, id: 3, locale: :en
    assert_redirected_to new_user_session_path
  end

  # Should be able to GET the finish_signup page
  test 'an oauth user should be able to finish their signup' do
    session['omniauth_uid'] = '123545'

    # Mock a new user coming from Twitter
    User.create!(
      email: 'change@me-123545-twitter.com',
      name: 'test user',
      password: '12345678',
      uid: '123545',
      provider: 'twitter'
    )

    get :finish_signup, locale: :en
    assert_response :success
  end

  # Should be abel to PUT to the finish_signup page
  test 'an oauth user without an email should be able save their completed signup' do
    session['omniauth_uid'] = '123545'

    # Mock a new user coming from Twitter
    u = User.create!(
      email: 'change@me-123545-twitter.com',
      name: 'test user',
      password: '12345678',
      uid: '123545',
      provider: 'twitter'
    )

    patch :finish_signup, { user: { email: "new@email.com", name: "test user" }, locale: :en }

    # Reload the user to pick up the changes
    u.reload
    # assert_response :success
    assert_equal u.email, "new@email.com"
  end


end
