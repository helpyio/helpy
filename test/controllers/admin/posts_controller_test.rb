# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  points     :integer          default(0)
#

require 'test_helper'

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  %w(user editor).each do |unauthorized|
    test "a #{unauthorized} should NOT be able to edit a post" do
      sign_in users(unauthorized.to_sym)
      original_post = Post.find(1)
      xhr :patch, :update, { id: 1, post: { body: "this has changed" }, locale: :en}
      assert original_post.body == Post.find(1).body
      assert :success
    end
  end

  %w(admin agent).each do |admin|

    test "an #{admin} should be able to see inactive posts" do

    end

    test "an #{admin} should be able to reply to a private topic, and the system should send an email" do
      sign_in users(admin.to_sym)

      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        assert_difference "Post.count", 1 do
          xhr :post, :create, topic_id: 1, locale: :en, post: { user_id: User.find(2).id, body: "new reply", kind: "reply" }
        end
      end
      assert :success
    end

    test "an #{admin} should be able to reply to a public topic, and the system should NOT send an email" do
      sign_in users(admin.to_sym)

      assert_difference "ActionMailer::Base.deliveries.size", 0 do
        assert_difference "Post.count", 1 do
          xhr :post, :create, topic_id: 4, locale: :en, post: { user_id: User.find(2).id, body: "new reply", kind: "reply" }
        end
      end
      assert :success
    end

    test "an #{admin} should be able to edit a post" do
      sign_in users(admin.to_sym)
      old = Post.find(1).body
      xhr :patch, :update, {id: 1, locale: :en, post: { body: "this has changed" }  }
      assert old != Post.find(1).body
      assert :success
    end

    test "an #{admin} should be able to post a reply to a pending ticket, and the topic status should change to open" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.where(current_status: 'open').count", 1 do
        xhr :post, :create, topic_id: 2, locale: :en, post: { user_id: User.find(1).id, body: "new reply", kind: "reply" }
      end
    end
  end

end
