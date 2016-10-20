require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase

  test 'Nothing sent of there are no agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "0"
    end

    notification = NotificationMailer.new_private(Topic.last)

    assert_emails 0 do
      notification.deliver_now
    end
  end

  test 'Should send one private message notification if there are agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "1"
    end

    notification = NotificationMailer.new_private(Topic.last)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.first
    assert_equal notification.bcc, User.notifiable_on_private.last(2)
  end

  test 'Should send one private message notification if there is one agents with notifications on' do
    User.agents.each do |a|
      a.settings.notify_on_private = "0"
    end
    User.agents.first.settings.notify_on_private = "1"

    notification = NotificationMailer.new_private(Topic.last)

    assert_emails 1 do
      notification.deliver_now
    end

    assert_equal notification.to[0], User.notifiable_on_private.first
    assert_equal notification.bcc, []
  end


end
