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

    assert_equal true, User.notifiable_on_private.collect{|u| u.email}.include?(notification.to[0])
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

    assert_equal true, User.notifiable_on_reply.collect{|u| u.email}.include?(notification.to[0])
  end

  # These tests make sure that notifications are sent out to all agents with them
  # turned on.
  test 'Should send one public message notification if there are agents with notifications on' do
    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal true, User.notifiable_on_public.collect{|u| u.email}.include?(notification.to[0])
    assert_equal notification.bcc, User.notifiable_on_public.last(2).collect {|u| u.email}
  end

  test 'Should send one reply message notification if there are agents with notifications on' do
    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal true, User.notifiable_on_reply.collect{|u| u.email}.include?(notification.to[0])
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

    assert_equal true, User.notifiable_on_private.collect{|u| u.email}.include?(notification.to[0])
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

    assert_equal true, User.notifiable_on_public.collect{|u| u.email}.include?(notification.to[0])
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
    assert_equal true, User.notifiable_on_reply.collect{|u| u.email}.include?(notification.to[0])
    assert_equal notification.bcc, []
  end


end
