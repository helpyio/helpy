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

class ApiKeysController < ApplicationController
end
