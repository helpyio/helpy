require 'test_helper'

class PostMailerTest < ActionMailer::TestCase

  setup do
    set_default_settings
  end

  test 'No mail sent if email is temporary placeholder' do
    topic = Topic.first
    user = topic.user
    user.email = "change@me-something.com"
    user.save!

    post = topic.posts.first
    email = PostMailer.new_post(post.id)

    assert_emails 0 do
      email.deliver_now
    end
  end

  test 'Post with CC or BCC should actually send to mailer' do
    topic = Topic.first
    post = topic.posts.create(body: "a response", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    email = PostMailer.new_post(post.id)

    assert_emails 1 do
      email.deliver_now
      assert_equal('cc@test.com', ActionMailer::Base.deliveries[0].cc[0])
      assert_equal('bcc@test.com', ActionMailer::Base.deliveries[0].bcc[0])
    end
  end
end
