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

  test 'No mail sent if topic is trashed' do
    topic = Topic.first
    topic.trash

    post = topic.posts.first
    email = PostMailer.new_post(post.id)

    assert_emails 0 do
      email.deliver_now
    end

  end

  test 'No mail sent if exceeding post per minute limit' do
    topic = Topic.find(1)
    12.times do
      topic.posts.create(
        kind: 'reply',
        user_id: 1,
        body: 'this is the body'
      )
    end

    post = topic.posts.last
    email = PostMailer.new_post(post.id)

    assert topic.posts.count > topic.posts_in_last_minute
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

  test 'Post mailer includes the header and footer' do
    header = Doc.create(title: 'Customer_header', body: 'test header', category_id: 2)
    footer = Doc.create(title: 'Customer_footer', body: '%ticket_link%', category_id: 2)

    topic = Topic.first
    post = topic.posts.create(body: "a response to %customer_name%", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    email = PostMailer.new_post(post.id)

    assert_emails 1 do
      email.deliver_now
      assert_equal true, email.html_part.body.to_s.include?(header.body)
      assert_equal true, email.html_part.body.to_s.include?(I18n.translate('view_online', default: 'View this online:'))
      assert_equal true, email.html_part.body.to_s.include?(topic.user.name)
    end
  end

  test 'Should still send if header and footer missing' do
    Doc.where(title: 'Customer_header').destroy_all
    Doc.where(title: 'Customer_footer').destroy_all

    topic = Topic.first
    post = topic.posts.create(body: "a response to %customer_name%", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    email = PostMailer.new_post(post.id)

    assert_emails 1 do
      email.deliver_now
    end
  end

  test 'Should not include history if disabled' do
    AppSettings['settings.include_ticket_history'] = '0'

    topic = Topic.first
    post = topic.posts.create(body: "first question", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    post = topic.posts.create(body: "this is the body", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    email = PostMailer.new_post(post.id)

    assert_emails 1 do
      email.deliver_now
      assert_equal true, email.html_part.body.to_s.include?("this is the body")
      assert_equal false, email.html_part.body.to_s.include?("first question")
    end
  end

  test 'Should not include body if disabled' do
    AppSettings['settings.include_ticket_body'] = '0'

    topic = Topic.first
    post = topic.posts.create(body: "first question", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    post = topic.posts.create(body: "this is the body", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'reply', user_id: '1')
    email = PostMailer.new_post(post.id)

    assert_emails 1 do
      email.deliver_now
      assert_equal false, email.html_part.body.to_s.include?("this is the body")
    end
  end


end
