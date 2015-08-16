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

  should belong_to(:voteable)

  test "a vote for a topic should increase its point count" do
    assert_difference('Topic.find(4).points',1) do
      Topic.find(4).votes.create(user_id: 1)
    end
  end

#  test "a vote for a topic should mark the last active date to today" do
#    assert_no_difference 'Vote.last.created_at', 'Topic.find(4).updated_at' do
#      Topic.find(4).votes.create(user_id: 1)
#    end
#  end

  test "a vote for a post should increase its point count" do
    assert_difference('Post.find(3).points',1) do
      Post.find(3).votes.create(user_id: 1)
    end
  end

#  test "a vote for a post should mark the last active date to today" do
#    assert_no_difference 'Time.now', 'Post.find(3).updated_at' do
#      Post.find(3).votes.create(user_id: 1)
#    end
#  end


  test "a user should only be able to vote for a voteable once" do

  end

end
