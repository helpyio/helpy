require 'test_helper'

class SlaRunnerJobTest < ActiveJob::TestCase

  test "should not run job if the current last post is not the post that created the check" do
    create_sla(tag = "violation 1", assigned_user_id = nil, group = nil)
    @topic = Topic.first
    assert_difference 'Violation.count', 0 do
      @post = @topic.posts.first
      SlaRunnerJob.perform_now(@sla.id, @post.id, @topic.id)
    end
  end

  test "should NOT run if the time is less than minutes" do
    create_sla(tag = "violation 1", assigned_user_id = nil, group = nil)
    @topic = Topic.first
    assert_difference 'Violation.count', 0 do
      @post = @topic.posts.create(body: 'reply from customer should generate jobs', user_id: 9, kind: 'reply')
      SlaRunnerJob.perform_now(@sla.id, @post.id, @topic.id)
    end
  end

  # test "should run if the time difference is greater than minutes" do
  #   create_sla(tag = "violation 1", assigned_user_id = nil, group = nil)
  #   @topic = Topic.first
  #   assert_difference 'Violation.count', 1 do
  #     @post = @topic.posts.create(body: 'reply from customer should generate jobs', user_id: 9, kind: 'reply')
  #     @post.update_attribute(:created_at, Time.now-2.hours)
  #     SlaRunnerJob.perform_now(@sla.id, @post.id, @topic.id)
  #   end
  # end
  #
  # test "should set up violation check jobs when a post is added" do
  #
  #   # create two slas
  #   create_sla(tag = "violation 1", assigned_user_id = nil, group = nil)
  #   create_sla(tag = "violation 2", assigned_user_id = nil, group = nil)
  #   @topic = Topic.first
  #   assert_enqueued_jobs 3 do
  #     @topic.posts.create(body: 'reply from customer should generate jobs', user_id: 9, kind: 'reply')
  #   end
  # end

  test "creating an admin reply should not enqueue a check" do
  end

  def create_sla(tag = nil, assigned_user_id = nil, group = nil)
    @sla = Sla.create!(
      name: '1 hour response',
      description: 'Respons within 1 hour',
      event: 'last_response',
      time: 1,
      time_units: 60,
      minutes: 60,
      tags: tag,
      assigned_user_id: assigned_user_id,
      group: group,
      active: true
    )
  end
end
