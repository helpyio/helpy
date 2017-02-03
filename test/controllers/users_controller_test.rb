# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string
#  identity_url           :string
#  name                   :string
#  admin                  :boolean          default(FALSE)
#  bio                    :text
#  signature              :text
#  role                   :string           default("user")
#  home_phone             :string
#  work_phone             :string
#  cell_phone             :string
#  company                :string
#  street                 :string
#  city                   :string
#  state                  :string
#  zip                    :string
#  title                  :string
#  twitter                :string
#  linkedin               :string
#  thumbnail              :string
#  medium_image           :string
#  large_image            :string
#  language               :string           default("en")
#  assigned_ticket_count  :integer          default(0)
#  topics_count           :integer          default(0)
#  active                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  provider               :string
#  uid                    :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  invitation_message     :text
#  time_zone              :string           default("UTC")
#  profile_image          :string
#  notify_on_private      :boolean          default(FALSE)
#  notify_on_public       :boolean          default(FALSE)
#  notify_on_reply        :boolean          default(FALSE)
#  account_number         :string
#  priority               :string           default("normal")
#

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
