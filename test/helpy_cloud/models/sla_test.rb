require 'test_helper'

class SlaTest < ActiveSupport::TestCase

  # create reply_received sla and set hours to on
  setup do
    Rails.application.config.active_job.queue_adapter == :inline
    create_sla('reply_received', "", nil, [])
    activate_days
  end


  test "should create violation event with escalation changes made to ticket" do
    create_sla('reply_received', "violation", 1, 'violations')
    @topic = Topic.first

    assert_difference 'Violation.count', 1 do
      assert_difference 'Notification.count', 2 do
        @sla.create_escalation(@topic.id, @topic.posts.where.not(kind: 'note').last.id)
      end
    end

    @topic.reload
    assert_equal 'violation', @topic.tag_list[0]
    assert_equal 1, @topic.assigned_user_id
  end

  test "should NOT create violation if ticket is not in group" do
    @sla.update_attribute(:selected_groups, ['shipping','billing'] )
    @topic = Topic.first

    assert_difference 'SlaSchedule.count', 0 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should NOT create violation if ticket is in a non included group" do
    @sla.update_attribute(:selected_groups, ['billing'] )
    @topic = Topic.first
    @topic.team_list = 'shipping'
    @topic.save

    assert_difference 'SlaSchedule.count', 0 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should create violation if ticket is in group" do
    @sla.update_attribute(:selected_groups, ['shipping','billing'] )

    @topic = Topic.first
    @topic.team_list = 'shipping'
    @topic.save

    assert_difference 'SlaSchedule.count', 1 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should create violation if ticket is in priority" do
    activate_days
    @sla.update_attribute(:selected_ticket_priorities, ['high'])

    @topic = Topic.first
    @topic.priority = 'high'
    @topic.save

    assert_difference 'SlaSchedule.count', 1 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should NOT create violation if ticket is not in priority" do
    @sla.update_attribute(:selected_ticket_priorities, ['high'])

    @topic = Topic.first
    @topic.priority = 'low'
    @topic.save

    assert_difference 'SlaSchedule.count', 0 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should create violation if ticket user is in priority" do
    @sla.update_attribute(:selected_user_priorities, ['high'])

    @topic = Topic.first
    user = @topic.user
    user.priority = 'high'
    user.save

    assert_difference 'SlaSchedule.count', 1 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should NOT create violation if ticket user is not in priority" do
    @sla.update_attribute(:selected_user_priorities, ['high'])

    @topic = Topic.first
    user = @topic.user
    user.priority = 'low'
    user.save

    assert_difference 'SlaSchedule.count', 0 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should create violation if groups are non restricted" do
    @topic = Topic.first
    @topic.team_list = 'shipping'
    @topic.save

    assert_difference 'SlaSchedule.count', 1 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should add check to schedule when post added" do
    @topic = Topic.first

    assert_difference 'SlaSchedule.count', 1 do
      @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    end
  end

  test "should add resolution check when new topic added" do
    @sla.update_attribute(:event, 'ticket_resolved')

    assert_difference 'SlaSchedule.count', 1 do
      topic = Topic.create!(user_id: 4, forum_id: 1, private: true, name: 'Topic subject')
      topic.posts.create!(body: 'abcdefg', kind: 'first', user_id: 4)
    end
  end

  test "should delete from the schedule when the escalation runs" do
    create_sla('reply_received', "violation", 1, '')
    @topic = Topic.first
    @topic.posts.create!(body: 'abcdefg', kind: 'reply', user_id: 4)
    schedule = SlaSchedule.last

    assert_difference 'Violation.count', 1 do
      assert_difference 'SlaSchedule.count', -1 do
        @sla.create_escalation(@topic.id, @topic.posts.last.id, schedule.id)
      end
    end
  end

  test "should delete from the schedule when the violation does not match" do
    @sla.update_attribute(:event, 'ticket_resolved')
    @topic = Topic.create!(user_id: 4, forum_id: 1, private: true, name: 'Topic subject', kind: 'first', current_status: 'closed')
    schedule = SlaSchedule.last

    assert_difference 'SlaSchedule.count', -1 do
      @sla.create_escalation(@topic.id, nil, schedule.id)
    end
  end

  test "should NOT create escalation if the current post is not the last post" do
    @sla.update_attribute(:minutes, 1)
    @topic = Topic.first
    # create two posts
    assert_difference 'SlaSchedule.count', +2 do
      @post1 = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply')
      @post2 = @topic.posts.create!(user_id: 9, body: 'abc', kind: 'reply')
    end

    assert_difference 'Violation.count', 0 do
      # create escalation with not the last post
      @sla.check_for_violation(@post1.id, @topic.id, nil)
    end
    assert_difference 'Violation.count', 1 do
      # create escalation with not the last post
      @sla.check_for_violation(@post2.id, @topic.id, nil)
    end
  end

  test "should NOT create escalation if the current post is written by agent" do
    create_sla('reply_received', "violation", 1, 'violations')
    @topic = Topic.first
    # Add a post by the agent
    @post = @topic.posts.create!(user_id: 1, body: 'xyz', kind: 'reply')

    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "should NOT create violation if the current post is a note" do
    create_sla('reply_received', "violation", 1, 'violations')
    @topic = Topic.first
    # Add a note by the agent
    @post = @topic.posts.create!(user_id: 1, body: 'xyz', kind: 'note')

    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "should NOT create violation if the current ticket is closed" do
    create_sla('reply_received', "violation", 1, 'violations')
    @topic = Topic.first
    # Add a reply and close the ticket
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply')
    @topic.update_attribute(:current_status, 'closed')

    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "should NOT create violation if the current ticket is spam" do
    create_sla('reply_received', "violation", 1, 'violations')
    @topic = Topic.first
    # Add a reply and close the ticket
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply')
    @topic.update_attribute(:current_status, 'spam')

    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  # Test SLA Hours

  test "should not create violation if all days are inactive" do
    create_sla('reply_received', "", nil, [])
    inactivate_days
    @topic = Topic.first
    # Add a reply and close the ticket
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply')
    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "if within hours, should generate violation" do

    create_sla('reply_received', "", nil, [])
    @topic = Topic.first
    # Add a reply, set created_at to be prior to 10am
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply', created_at: Time.now.utc.at_beginning_of_day + 9.hours)

    assert_difference 'Violation.count', 1 do
      @sla.check_for_violation(@post.id, @topic.id, nil, Time.now.utc.at_beginning_of_day + 10.hours)
    end
  end

  test "if hours are not supplied, should create a violation no matter the time" do

    create_sla('reply_received', "", nil, [])
    @sla.update_attribute(:set_hours, false)

    @topic = Topic.first
    # Add a reply, set created_at to be prior to 10am
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply', created_at: Time.now.utc.at_beginning_of_day + 1.hours)

    assert_difference 'Violation.count', 1 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "if outside support hours, should NOT generate violation" do

    create_sla('reply_received', "", nil, [])
    @topic = Topic.first
    # Add a reply and close the ticket
    @post = @topic.posts.create!(user_id: 9, body: 'xyz', kind: 'reply')

    assert_difference 'Violation.count', 0 do
      @sla.check_for_violation(@post.id, @topic.id, nil)
    end
  end

  test "#scheduled_sla_check should return sla minutes if scheduling off" do
    create_sla('reply_received', "", nil, [])
    @sla.set_hours == false
    @sla.save

    assert (Time.now.utc + @sla.minutes.minutes).to_a == @sla.scheduled_sla_check(Topic.last).to_a,
    "#{Time.now.utc + @sla.minutes.minutes} not equal to #{@sla.scheduled_sla_check(Topic.last)}"
  end

  test "#scheduled_sla_check should adhear to schedule" do
    create_sla('reply_received', "", nil, [])
    @sla.set_hours = true
    @sla.save
    activate_days

    assert (Time.now.utc.at_beginning_of_day + @sla.minutes.minutes + 9.hours + 10.minutes).to_a == @sla.scheduled_sla_check(Topic.last, Time.now.utc.at_beginning_of_day).to_a,
    "#{Time.now.utc.at_beginning_of_day + @sla.minutes.minutes + 9.hours} not equal to #{@sla.scheduled_sla_check(Topic.last, Time.now.utc.at_beginning_of_day)}"
  end

  test "#scheduled_sla_check should adhear to schedule across weekend with no hours" do
    create_sla('reply_received', "", nil, [])
    activate_days
    @sla.saturday_active = false
    @sla.sunday_active = false
    @sla.set_hours = true
    @sla.minutes = 180
    @sla.save

    # create a ticket at 4pm on friday, should not SLA until monday
    friday_at_four = Time.now.utc.at_beginning_of_week + 4.days + 16.hours
    monday_at_ten = Time.now.utc.at_beginning_of_week + 7.days + 10.hours + 10.minutes
    topic = Topic.create!(forum_id: 1, name: 'something', user_id: 9, current_status: "new", created_at: friday_at_four)
    post = Post.create!(topic_id: topic.id, kind: 'first', user_id: 9, body: 'test', created_at: friday_at_four)
    assert (monday_at_ten).to_a == @sla.scheduled_sla_check(topic, friday_at_four).to_a,
    "#{monday_at_ten} not equal to #{@sla.scheduled_sla_check(topic, friday_at_four)}"
  end

  test '#support_active_today should be false if no support hours' do
    create_sla('reply_received', "", nil, [])
    inactivate_days

    assert_equal false, @sla.support_active_today(Time.now)
    assert_equal false, @sla.support_active_today(date_of_next("Saturday"))
  end

  test '#support_active_today should be true if support hours enabled for day' do
    activate_days

    assert_equal true, @sla.support_active_today(Time.now)
  end

  test '#has_support_hours should be true if within hours' do
    assert_equal true, @sla.has_support_hours(Time.now.utc.at_beginning_of_day + 10.hours)
  end

  test '#has_support_hours should be false if outside hours' do
    assert_equal false, @sla.has_support_hours(Time.now.utc.at_beginning_of_day)
  end

  test "all_days_inactive should be true if all days inactive" do
    inactivate_days

    assert_equal true, @sla.all_days_inactive?
  end

  def create_sla(event = 'reply_received', tag = "", assigned_user_id = nil, group = "", groups = [])
    @sla = Sla.create!(
      name: '1 minute response',
      description: 'Respons within 1 minute',
      event: event,
      time: 1,
      time_units: 60,
      minutes: 60,
      selected_groups: groups,
      tags: tag,
      assigned_user_id: assigned_user_id,
      group: group,
      notify_users: [1,6],
      active: true,
      set_hours: false
    )
  end

  def inactivate_days
    @sla.set_hours = true
    @sla.sunday_active = false
    @sla.monday_active = false
    @sla.tuesday_active = false
    @sla.wednesday_active = false
    @sla.thursday_active = false
    @sla.friday_active = false
    @sla.saturday_active = false
    @sla.save!
  end

  def activate_days
    @sla.set_hours = true
    @sla.sunday_active = true
    @sla.monday_active = true
    @sla.tuesday_active = true
    @sla.wednesday_active = true
    @sla.thursday_active = true
    @sla.friday_active = true
    @sla.saturday_active = true
    @sla.save!
  end

  def date_of_next(day)
    date  = Date.parse(day)
    delta = date > Date.today ? 0 : 7
    date + delta
  end

end
