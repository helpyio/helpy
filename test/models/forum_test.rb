# == Schema Information
#
# Table name: forums
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  topics_count       :integer          default(0), not null
#  last_post_date     :datetime
#  last_post_id       :integer
#  private            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  allow_topic_voting :boolean          default(FALSE)
#  allow_post_voting  :boolean          default(FALSE)
#  layout             :string           default("table")
#

require 'test_helper'

class ForumTest < ActiveSupport::TestCase

  should have_many(:topics)
  should have_many(:posts)

  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)

  should validate_presence_of(:description)
  should validate_length_of(:description).is_at_most(1000)

  test "should count number of posts" do
    # For sum of array, see
    # https://stackoverflow.com/questions/1538789/how-to-sum-array-of-numbers-in-ruby
    assert Forum.find(1).total_posts == Forum.find(1).topics.collect{|t| t.posts.count}.inject(0, :+)
  end

  test "to_param" do
    assert Forum.find(1).to_param == "1-private-tickets"
  end

  test "creating new lowercase name should be saved in sentence_case" do
    name = "something in lowercase"
    forum = create :forum, name: name
    assert_equal name.sentence_case, forum.name
  end

  test "when creating a new category, any other capitals should be saved as entered" do
    name = "something in lowercase and UPPERCASE"
    forum = create :forum, name: name
    assert_equal name.sentence_case, forum.name
  end

end
