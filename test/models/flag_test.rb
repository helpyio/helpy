# == Schema Information
#
# Table name: flags
#
#  id                 :integer          not null, primary key
#  post_id            :integer
#  generated_topic_id :integer
#  reason             :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  should belong_to(:post)
end
