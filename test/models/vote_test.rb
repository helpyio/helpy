# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  points        :integer          default(1)
#  voteable_type :string
#  voteable_id   :integer
#  user_id       :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class VoteTest < ActiveSupport::TestCase

end
