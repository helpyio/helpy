# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  should belong_to(:forum)
  should belong_to(:user)
  should have_many(:posts)
  should validate_presence_of(:name)
  should have_many(:votes)

#forum 1 should exist and be private
#forum 2 should exist and be private



  test "to_param" do
    assert Topic.find(1).to_param == "1-private-topic"
  end

  test "a new discussion should have status of NEW" do
    @topic = Topic.create(forum_id: 1, user_id: 2, name: "A test topic")
    assert @topic.current_status == "new"
  end

  test "a new topic should cache the creators name" do

    @user = User.first
    @topic = Topic.create(forum_id: 1, name: "Test topic", user_id: @user.id)

    assert @topic.user_name = @user.name

  end

  test "trashed messages should be in forum 2, and unassigned" do

    Topic.all.each do |topic|

      topic.trash

      assert topic.assigned_user_id.nil?
      assert topic.forum_id == 2
      assert topic.private?
      assert topic.current_status == 'trash'
      assert_not_nil topic.closed_date

    end
  end

  test "closed messages should be unassigned" do

    Topic.all.each do |topic|

      topic.close

      assert topic.assigned_user_id.nil?
      assert topic.current_status == 'closed'
      assert_not_nil topic.closed_date

    end
  end

  test "creating new lowercase name should be saved in sentence_case" do
    name = "something in lowercase"
    topic = Topic.create!(name: name, user_id: 1, forum_id: 1)
    assert_equal "Something in lowercase", topic.name
  end

  test "when creating a new topic, any other capitals should be saved as entered" do
    name = "something in lowercase and UPPERCASE"
    topic = Topic.create!(name: name, user_id: 1, forum_id: 1)
    assert_equal "Something in lowercase and UPPERCASE", topic.name
  end

end
