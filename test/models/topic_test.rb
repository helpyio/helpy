# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  forum_id       :integer
#  user_id        :integer
#  name           :string
#  posts_count    :integer          default(0), not null
#  last_post_date :datetime
#  last_post_id   :integer
#  status         :string           default("Open")
#  private        :boolean          default(FALSE)
#  cheatsheet     :boolean          default(FALSE)
#  points         :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
