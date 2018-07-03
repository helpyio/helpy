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
#

require 'test_helper'

class API::V1::UsersTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Users Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    get '/api/v1/users.json'

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return users" do
    get '/api/v1/users.json', @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == User.count, "Only #{objects.length} returned out of #{User.count} users"
  end

  test "an API user should be able to search for a specific user" do
    params = {
      q: "Editor"
    }
    get '/api/v1/users/search.json', @default_params.merge(params)

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == 1, "#{objects.length} returned instead of one matching user"
  end

  test "an API user should be able to return a specific user" do
    user = User.find(2)
    get "/api/v1/users/#{user.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert_equal object[0]['id'], user.id
  end

  test "an API user should be able to create a user" do
    params = {
      name: "Tom Brady",
      email: "tom@test.com",
      password: "12345678"
    }

    post '/api/v1/users.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
  end

  test "an API user should not be able to create an invalid user" do
    params = {
      name: "Tom Brady",
      email: nil,
      password: "12345678"
    }

    post '/api/v1/users.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a user" do
    user = User.find(2)
    params = {
      name: user.name,
      email: "newaddress@me.com",
      password: "12345678"
    }

    patch "/api/v1/users/#{user.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
    assert_equal params[:email], object['email']
  end

  test "an API user should be able to invite one or more users to be agents" do
    params = {
      emails: "newaddress@me.com",
      message: "Join me at Helpy",
      role: "agent"
    }

    post "/api/v1/users/invite.json", @default_params.merge(params)

    invited_user = User.where(email: "newaddress@me.com").first

    # Ensure the invited user has a token
    assert_not_equal invited_user.invitation_token, nil
  end

  test "an API user can delete users" do
    user = User.create!(name: "foo", email: "foo@bar.com", password: "password")
    delete "/api/v1/users/#{user.id}.json", @default_params

    assert_equal 204, last_response.status
  end

  test "an API user can anonymize users" do
    user = User.create!(name: "foo", email: "foo@bar.com", password: "password")
    post "/api/v1/users/anonymize/#{user.id}.json", @default_params

    object = JSON.parse(last_response.body)

    assert_equal "Anonymous User", object['name']
    assert_equal "anon", object['login']
    assert_nil object['city']
  end
end
