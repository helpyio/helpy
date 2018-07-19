# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  name         :string
#  date_expired :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase

  should belong_to(:user)

  test "creating a new api key should generate an access token" do
    api_key = create :api_key
    assert_not_nil api_key.access_token
  end

  test "updating an existing api key should not modify its access token" do
    api_key = create :api_key
    access_token = api_key.access_token
    api_key.name = "ChangedApiKeyName"
    api_key.save!
    assert_equal access_token, api_key.access_token
  end

  test "expired should be false" do
    api_key = create :api_key
    assert (api_key.expired? == false), "ApiKey#expired? should be false when date_expired is not present"
  end

  test "expired should be true" do
    api_key = create :api_key, :expired
    assert (api_key.expired? == true), "ApiKey#expired? should be true when date_expired is present"
  end

end
