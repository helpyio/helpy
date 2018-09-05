require 'test_helper'

# Triggers hook into the ticket lifecycle with callbacks, and can have
# multiple actions that can be carried out, this loops through each and
# either does the action or sends to queue

# actions include
# [x] agent- assign to a specific agent
# [x] any_agent - assigns to next agent
# [x] least_agent - the least busy agent
# [x] unassign_agent - unassign from any agent
# [x] internal_note - write an internal note
# [x] reply - write a reply to the ticket
# [x] assign_group - assign to a group
# [x] resolve - mark resolved
# [x] read_only - make read_only
# [x] remove_read_only - remove read_only
# [x] trash
# [ ] mark spam
# [x] reopen
# [x] json_hook
# [x] slack

# [x] alert- touch and make pending
# [ ] new_ticket- create a new ticket
# [ ] forum_id - make public, move, make private

# [ ] sla_violation - timebased

class EventJobTest < ActiveJob::TestCase

  def create_ticket
    @topic = Topic.create(
      name: 'This is the topic',
      forum_id: 1,
      private: true,
      user_id: 1,
      post_cache: 'this is the cache'
    )
  end

  test "should assign to a specific agent" do
    create_ticket
    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test assign to agent',
      actions: ['agent, 3'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_equal(3, @topic.assigned_user_id)
  end

  test "should assign to an agent" do
    create_ticket
    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test assign to any agent',
      actions: ['any_agent,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_not_nil(@topic.assigned_user_id)
  end

  test "should assign to the least busy agent" do
    create_ticket
    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test assign to least busy agent',
      actions: ['least_agent,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_not_nil(@topic.assigned_user_id)
  end

  test "should unassign an assigned ticket" do
    create_ticket

    # assign this ticket
    @topic.assigned_user_id = 1
    @topic.save

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test unassign from agent',
      actions: ['unassign_agent,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_nil(@topic.assigned_user_id)
  end

  test "should add an internal note" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test write an internal note',
      actions: ['internal_note,This is the note'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_equal('This is the note',@topic.posts.last.body)
    assert_equal('note',@topic.posts.last.kind)
  end

  test "should add a reply" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test add a reply',
      actions: ['post_reply,This is the reply'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_equal('This is the reply',@topic.posts.last.body)
    assert_equal('reply',@topic.posts.last.kind)
  end

  test "should assign to a group" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test assign to a group',
      actions: ['group,billing'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload
    assert_equal('billing',@topic.team_list[0])
  end

  test "should mark resolved" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test resolve ticket',
      actions: ['resolve,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload

    assert_equal('closed',@topic.current_status)
  end

  test "should trash" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test trashing ticket',
      actions: ['trash,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload

    assert_equal('trash',@topic.current_status)
  end

  test "should reopen" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test reopening ticket',
      actions: ['reopen,'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    @topic.reload

    assert_equal('open',@topic.current_status)
  end

  test "should do multiple actions" do
    create_ticket

    # Create a trigger that assigns agent on a new topic
    trigger = Trigger.create(
      name: 'test reopening ticket',
      actions: ['reopen,','internal_note,reopened by trigger', 'post_reply,yoyoyo'],
      conditions: [','],
      event: 'ticket_created'
    )

    EventJob.perform_now(trigger.id, @topic.id)
    # assert_equal('open',@topic.current_status)
    assert_equal('reopened by trigger',@topic.posts.where(kind: 'note').last.body)
    assert_equal('yoyoyo',@topic.posts.where(kind: 'reply').last.body)
  end

end
