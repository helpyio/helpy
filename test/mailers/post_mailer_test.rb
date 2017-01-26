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

end
