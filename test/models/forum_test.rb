# == Schema Information
#
# Table name: forums
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  topics_count   :integer          default(0), not null
#  last_post_date :datetime
#  last_post_id   :integer
#  private        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
