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

  test "creating a new Api Key should generate an access token" do
    api_key = ApiKey.create!(name: "MyApiKey")
    assert_not_nil api_key.access_token
  end

end
