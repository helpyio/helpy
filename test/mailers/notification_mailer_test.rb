require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase

  # This test makes sure no notification is sent if notifications are turned off
  # for everyone
  test 'Should not send if there are no agents with private notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "0"
    end

    notification = NotificationMailer.new_private(Topic.last.id)

    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one private message notification if there are agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "1"
    end

    notification = NotificationMailer.new_private(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.first
    assert_equal notification.bcc, User.notifiable_on_private.last(2)
  end

  test 'Should not send if there are no agents with public notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_public = "0"
    end

    notification = NotificationMailer.new_public(Topic.last.id)
    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one notification if there are agents with public notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_public = "1"
    end

    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.first
    assert_equal notification.bcc, User.notifiable_on_public.last(2)
  end

  test 'Should not send if there are no agents with reply notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_reply = "0"
    end

    notification = NotificationMailer.new_reply(Topic.last.id)
    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one notification if there are agents with reply notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_reply = "1"
    end

    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_reply.first
    assert_equal notification.bcc, User.notifiable_on_reply.last(2)
  end

  # These tests make sure that notifications are sent out to all agents with them
  # turned on.
  test 'Should send one public message notification if there are agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_public = "1"
    end

    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.first
    assert_equal notification.bcc, User.notifiable_on_public.last(2)
  end

  test 'Should send one reply message notification if there are agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_reply = "1"
    end

    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_reply.first
    assert_equal notification.bcc, User.notifiable_on_reply.last(2)
  end


  # These tests check to make sure it works if there is only one agent with a notification
  test 'Should send one private message notification if there is one agent with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "0"
    end
    User.agents.first.settings.notify_on_private = "1"

    notification = NotificationMailer.new_private(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.first
    assert_equal notification.bcc, []
  end

  test 'Should send one public message notification if there is one agent with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_public = "0"
    end
    User.agents.first.settings.notify_on_public = "1"

    notification = NotificationMailer.new_public(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_public.first
    assert_equal notification.bcc, []
  end

  test 'Should send one reply message notification if there is one agent with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_reply = "0"
    end
    User.agents.first.settings.notify_on_reply = "1"

    notification = NotificationMailer.new_reply(Topic.last.id)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_reply.first
    assert_equal notification.bcc, []
  end


end
