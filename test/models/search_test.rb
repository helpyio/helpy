# == Schema Information
#
# Table name: searches
#
#  id              :integer          not null, primary key
#  name            :string
#  body            :text
#  search_type     :string
#  search_id       :integer
#  last_updated_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
