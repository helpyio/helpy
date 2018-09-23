require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase

  def setup
    set_default_settings
  end

  def disable_all_notifications
    User.agents.each do |a|
      a.notify_on_private = false
      a.notify_on_public = false
      a.notify_on_reply = false
      a.save!
    end
  end

  

  # This test makes sure no notification is sent if notifications are turned off
  # for everyone
  test 'Should not send if there are no agents with private notifications on' do
    disable_all_notifications
    notification = NotificationMailer.new_private(Topic.last.id)

    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one private message notification if there are agents with notifications on' do
    notification = NotificationMailer.new_private(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.collect {|u| u.email}.first
    assert_equal notification.bcc, User.notifiable_on_private.last(2).collect {|u| u.email}
  end

  test 'Should not send if there are no agents with public notifications on' do
    disable_all_notifications
    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one notification if there are agents with public notifications on' do
    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.collect {|u| u.email}.first
    assert_equal notification.bcc, User.notifiable_on_public.last(2).collect {|u| u.email}
  end

  test 'Should not send if there are no agents with reply notifications on' do
    disable_all_notifications
    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one notification if there are agents with reply notifications on' do
    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_reply.collect {|u| u.email}.first
    assert_equal notification.bcc, User.notifiable_on_reply.last(2).collect {|u| u.email}
  end

  # These tests make sure that notifications are sent out to all agents with them
  # turned on.
  test 'Should send one public message notification if there are agents with notifications on' do
    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.collect {|u| u.email}.first
    assert_equal notification.bcc, User.notifiable_on_public.last(2).collect {|u| u.email}
  end

  test 'Should send one reply message notification if there are agents with notifications on' do
    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_reply.collect {|u| u.email}.first
    assert_equal notification.bcc, User.notifiable_on_reply.last(2).collect {|u| u.email}
  end


  # These tests check to make sure it works if there is only one agent with a notification
  test 'Should send one private message notification if there is one agent with notifications on' do
    disable_all_notifications
    user = User.agents.first
    user.notify_on_private = true
    user.save!

    notification = NotificationMailer.new_private(Topic.last.id)
    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.collect {|u| u.email}.first
    assert_equal notification.bcc, []
  end

  test 'Should send one public message notification if there is one agent with notifications on' do
    disable_all_notifications
    user = User.agents.first
    user.notify_on_public = true
    user.save!

    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.collect {|u| u.email}.first
    assert_equal notification.bcc, []
  end

  test 'Should send one reply message notification if there is one agent with notifications on' do
    disable_all_notifications
    user = User.agents.first
    user.notify_on_reply = true
    user.save!
    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end
    assert_equal notification.to[0], User.notifiable_on_reply.collect {|u| u.email}.first
    assert_equal notification.bcc, []
  end

  #set data for test email include attachment
  def data_for_attachment_test
    disable_all_notifications
    @user = User.agents.first
    @user_1 = User.create(email: "test@example.com", name: "tester", password: '12345678')
    @topic_1 = Topic.create(name: 'topic-test', user_id: @user_1.id, forum_id: 5)
    @post_1 = Post.create(body: 'body-test', user_id: @user_1.id, kind: 'everything', topic_id: @topic_1.id)
  end

# These tests check the notification email will include attachment with new_private method
  def notification_email_for_private_test
    @private_notification = NotificationMailer.new_private(@topic_1.id)
    @private_notification.deliver_now
    assert_equal @private_notification.subject, "[Helpy Support] ##{@user_1.id}-Topic-test"
    assert_equal @private_notification.to, ["guy@test.com"]
  end

  def notify_on_private_true
    data_for_attachment_test
    @user.notify_on_private = true
    @user.save!
  end
  
  test "Should include attachment on private notification email if user's ticket has this one " do
    notify_on_private_true
    @post_1.attachments = [Pathname.new('test/fixtures/files/logo.png').open]
    @post_1.save
    notification_email_for_private_test
    assert_equal @private_notification.attachments.first.filename, 'logo.png'
  end

  test "Should not include attachment on private notification email if user's ticket has not this one " do
    notify_on_private_true
    notification_email_for_private_test
    assert_equal @private_notification.attachments, []
  end

# These tests check the notification email will include attachment with new_public method
  def notification_email_for_public_test
    @public_notification = NotificationMailer.new_public(@topic_1.id)
    @public_notification.deliver_now
    assert_equal @public_notification.subject, "[Helpy Support] ##{@user_1.id}-Topic-test"
    assert_equal @public_notification.to, ["guy@test.com"]
  end

  def notify_on_public_true
    data_for_attachment_test
    @user.notify_on_public = true
    @user.save!
  end

  test "Should include attachment on public notification email if user's ticket has this one " do
    notify_on_public_true
    @post_1.attachments = [Pathname.new('test/fixtures/files/logo.png').open]
    @post_1.save
    notification_email_for_public_test
    assert_equal @public_notification.attachments.first.filename, 'logo.png'
  end

  test "Should not include attachment on public notification email if user's ticket has not this one " do
    notify_on_public_true
    notification_email_for_public_test
    assert_equal @public_notification.attachments, []
  end

# These tests check the notification email will include attachment with new_reply method
  def notification_email_for_reply_test
    @reply_notification = NotificationMailer.new_reply(@topic_1.id)
    @reply_notification.deliver_now
    assert_equal @reply_notification.subject, "[Helpy Support] ##{@user_1.id}-Topic-test"
    assert_equal @reply_notification.to, ["guy@test.com"]
  end

  def notify_on_reply_true
    data_for_attachment_test
    @user.notify_on_reply = true
    @user.save!
  end

  test "Should include attachment on reply notification email if user's ticket has this one " do
    notify_on_reply_true
    @post_1.attachments = [Pathname.new('test/fixtures/files/logo.png').open]
    @post_1.save
    notification_email_for_reply_test
    assert_equal @reply_notification.attachments.first.filename, 'logo.png'
  end

  test "Should not include attachment on reply notification email if user's ticket has not this one " do
    notify_on_reply_true
    notification_email_for_reply_test
    assert_equal @reply_notification.attachments, []
  end
end



