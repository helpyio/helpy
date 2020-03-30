require "test_helper"

class Admin::TopicsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
    set_default_settings
  end

  %w(admin agent).each do |admin|

    ### Topic split
    test "an #{admin} should be able to split a ticket" do
      sign_in users(admin.to_sym)

      post :split_topic, topic_id: 1, post_id: 1
      assert_response :redirect
    end

    test "an #{admin} splitting a topic should create a new topic" do
      sign_in users(admin.to_sym)

      assert_difference "Topic.count", 1 do
        post :split_topic, topic_id: 1, post_id: 1
      end
    end

    test "an #{admin} splitting a topic should create 2 new posts" do
      sign_in users(admin.to_sym)

      assert_difference "Post.count", 2 do
        post :split_topic, topic_id: 1, post_id: 1
      end
    end

    test "#{admin}: split topic owner should be owner of post split from" do
      sign_in users(admin.to_sym)
      post :split_topic, topic_id: 4, post_id: 4
      assert_equal Topic.all.last.user_id, Post.find(4).user_id
    end

    test "#{admin}: split topic should have the same channel as the original topic" do
      sign_in users(admin.to_sym)
      post :split_topic, topic_id: 4, post_id: 4
      assert_equal Topic.all.last.channel, Post.find(4).topic.channel
    end

    ### Topic Views

    test "an #{admin} should be able to see a list of topics via standard request" do
      sign_in users(admin.to_sym)

      get :index, { status: "open" }
      assert_not_nil assigns(:topics)
      assert_template "admin/topics/index"
      assert_response :success
    end

    test "an #{admin} should be able to filter topics by providing a group parameter" do
      sign_in users(admin.to_sym)

      # Assign agent and topic to a group
      agent = users(admin)
      topic = topics(:private)
      topic.current_status = "open"
      topic.team_list = "test"
      topic.save!

      get :index, { status: "open", team: 'test' }
      assert_not_nil assigns(:topics)
      assert_equal 1, assigns(:topics).size
      assert_template "admin/topics/index"
      assert_response :success
    end

    test "an #{admin} should be able to see a list of topics via ajax" do
      sign_in users(admin.to_sym)

      xhr :get, :index, { status: "open" }, format: :js
      assert_not_nil assigns(:topics)
      assert_template "admin/topics/index"
      assert_response :success
    end

    test "an #{admin} should be able to see a specific topic of each type via standard request" do
      sign_in users(admin.to_sym)
      [3,7].each do |topic_id|
        get :show, { id: topic_id }
        assert_not_nil assigns(:topic)
        assert_template "admin/topics/show"
        assert_response :success
      end
    end

    test "an #{admin} should be able to see a specific topic of each type via ajax" do
      sign_in users(admin.to_sym)
      [3,7].each do |topic_id|
        xhr :get, :show, { id: topic_id }
        assert_not_nil assigns(:topic)
        assert_template "admin/topics/show"
        assert_response :success
      end
    end

    ### Assigning topic tests

    test "an #{admin} should be able to assign an unassigned discussion" do
      sign_in users(admin.to_sym)
      assert_difference "Post.count", 1 do
        xhr :get, :assign_agent, { topic_ids: [1], assigned_user_id: 1 }
      end
      assert_response :success
    end

    test "an #{admin} should be able to assign a previously assigned discussion" do
      sign_in users(admin.to_sym)
      assert_difference "Post.count", 1 do
        xhr :get, :assign_agent, { topic_ids: [3], assigned_user_id: 1 }
      end
      assert_response :success
    end

    test "an #{admin} should be able to assign multiple tickets" do
      sign_in users(admin.to_sym)
      assert_difference "Post.count", 2 do
        xhr :get, :assign_agent, { topic_ids: [3,2], assigned_user_id: 1 }
      end
      assert_response :success
    end

    test "an #{admin} assigning a discussion to a different agent should create a note" do
      sign_in users(admin.to_sym)
      assert_difference "Post.count", 1 do
        xhr :get, :assign_agent, { assigned_user_id: 1, topic_ids: [1] }
      end
      assert_response :success
    end

    test "an #{admin} should be able to unassign an agent" do
      sign_in users(admin.to_sym)
      topic = Topic.find(1)
      topic.assigned_user_id = 1
      topic.save!
      assert_difference "Post.count", 1 do
        xhr :get, :unassign_agent, { assigned_user_id: nil, topic_ids: [1] }
      end
      assert_response :success
      topic.reload
      assert_nil topic.assigned_user_id, "assigned user should be nil"
    end

    test "an #{admin} should be able to assign a ticket and have the CC persisted" do
      sign_in users(admin.to_sym)
      topic = Topic.find(1)
      post = topic.posts.where(kind: 'reply').last
      post.cc = "test@test.com"
      post.save!

      assert_difference "Post.count", 1 do
        xhr :get, :assign_agent, { topic_ids: [1], assigned_user_id: 1 }
      end

      post2 = Post.new_with_cc(topic)
      post2.body = "test"
      post2.kind = "reply"
      post2.user_id = 1
      post2.cc = topic.posts.ispublic.order(id: :asc).last&.cc
      post2.save!

      assert_equal "test@test.com", post2.cc
    end

    ### tests of changing status

    test "an #{admin} posting an internal note should not change status on its own" do

    end

    test "an #{admin} should be able to change an open ticket to closed" do
      sign_in users(admin.to_sym)
      assert_difference("Post.count") do
        xhr :get, :update_topic, { topic_ids: [2], change_status: "closed" }
      end
      assert_response :success
    end

    test "an #{admin} should be able to change a closed ticket to open" do
      sign_in users(admin.to_sym)
      assert_difference("Post.count") do
        xhr :get, :update_topic, { topic_ids: [3], change_status: "reopen" }
      end
      assert_response :success
      assert_template layout: nil
    end

    test "an #{admin} should be able to change an open ticket to spam" do
      sign_in users(admin.to_sym)
      xhr :get, :update_topic, { topic_ids: [2], change_status: "spam" }
      assert_response :success
      assert_template layout: nil
    end

    test "an #{admin} should be able to change the status of multiple topics at once" do
      sign_in users(admin.to_sym)
      assert_difference("Post.count",2) do
        xhr :get, :update_topic, { topic_ids: [2,3], change_status: "closed" }
      end
      assert_response :success
    end

    test "an #{admin} should be able to merge multiple topics into one" do
      sign_in users(admin.to_sym)
      assert_difference("Topic.count",1) do
        xhr :get, :merge_tickets, { topic_ids: [2,3] }
      end
      assert_response :success
    end

    # Test assigning tags to a topic

    test "an #{admin} should be able to assign and change tags for a topic" do
      sign_in users(admin.to_sym)
      xhr :patch, :update_tags, { id: 2, topic: { tag_list: 'hello, hi' } }
      assert_equal 2, Topic.find(2).tag_list.count
      assert_equal true, Topic.find(2).tag_list.include?("hi")
    end

    test "an #{admin} should be able to remove tags for a topic" do
      sign_in users(admin.to_sym)
      t = Topic.find(2)
      t.tag_list = "tag1, tag2"
      t.save
      xhr :patch, :update_tags, { id: 2, topic: { tag_list: '' } }
      assert_equal 0, Topic.find(2).tag_list.count
    end

    ### testing new discussion creation and lifecycle

    test "an #{admin} should be able to open a new discussion for a new user" do
      sign_in users(admin.to_sym)
      xhr :get, :new
      assert_response :success
    end

    test "an #{admin} should be able to open a new discussion with a set channel" do
      AppSettings['settings.default_channel'] = 'phone'
      sign_in users(admin.to_sym)
      xhr :get, :new
      assert_equal 'phone', assigns(:topic).channel
      assert_response :success
    end

    test "an #{admin} should be able to create a new private discussion for a new user with an email" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            assert_difference "ActionMailer::Base.deliveries.size", 3 do
              xhr :post, :create, topic: { user: { name: "a user", email: "anon@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
            end
          end
        end
      end
    end

    test "an #{admin} should be able to create a new private discussion for a new user with a mixed case email" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            assert_difference "ActionMailer::Base.deliveries.size", 3 do
              xhr :post, :create, topic: { user: { name: "a user", email: "Anon@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
            end
          end
        end
      end
    end

    test "an #{admin} should be able to create a new private discussion for an existing user with an email" do
      sign_in users(admin.to_sym)
      existing_user = users(:user)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          xhr :post, :create, topic: { user: { name: "scott", email: "scott.miller@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
        end
      end
    end

    test "an #{admin} should be able to create a new private discussion for an existing user with a mixed case email" do
      sign_in users(admin.to_sym)
      existing_user = users(:user)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          xhr :post, :create, topic: { user: { name: "scott", email: "Scott.Miller@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
        end
      end
    end

    test "an #{admin} should be able to create a new private discussion for a new user with a phone number" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            xhr :post, :create, topic: { user: { name: "a user", home_phone: '34526668', email: "change@me-34526668.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
          end
        end
      end

      assert_equal "34526668", User.last.home_phone
    end

    test "an #{admin} created private discussion should have channel" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            xhr :post, :create, topic: { user: { name: "a user", work_phone: '34526668', email: "change@me-34526668.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, channel: "phone", forum_id: 1, current_status: 'new'}
          end
        end
      end

      assert_equal "phone", Topic.last.channel
    end

    test "an #{admin} created private discussion with assignment should be assigned" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            xhr :post, :create, topic: { user: { name: "a user", work_phone: '34526668', email: "change@me-34526668.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, channel: "phone", forum_id: 1, current_status: 'new', assigned_user_id: 1}
          end
        end
      end

      assert_equal 1, Topic.last.assigned_user_id
    end

    test "an #{admin} created private discussion without assignment should be unassigned" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            xhr :post, :create, topic: { user: { name: "a user", work_phone: '34526668', email: "change@me-34526668.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, channel: "phone", forum_id: 1, current_status: 'new', assigned_user_id: nil}
          end
        end
      end

      assert_nil Topic.last.assigned_user_id
    end

    test "an #{admin} should be able to create a new private discussion for an existing user" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_no_difference "User.count" do
            assert_difference "ActionMailer::Base.deliveries.size", 2 do
              xhr :post, :create, topic: { user: { name: "Scott Smith", email: "scott.smith@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new' }
            end
          end
        end
      end
    end

    test "an #{admin} should be able to create an internal ticket without sending an email to customer" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_no_difference "User.count" do
            assert_difference "ActionMailer::Base.deliveries.size", 1 do
              xhr :post, :create, topic: { user: { name: "Scott Smith", email: "scott.smith@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new', kind: 'internal' }
            end
          end
        end
      end
    end

    test "an #{admin} should be able to create an internal ticket and create a new user" do
      sign_in users(admin.to_sym)
      assert_difference "User.count", 1 do
        xhr :post, :create, topic: { user: { name: "Joe Smith", email: "joe.smith34@test.com" }, name: "some new private topic", post: { body: "this is the body", kind: 'first' }, forum_id: 1, current_status: 'new', kind: 'internal' }
      end
    end

    ### test assign_team and unassign_team

    test "an #{admin} should be able to assign_team of a topic" do
      sign_in users(admin.to_sym)
      xhr :get, :assign_team, { topic_ids: [1], assign_team: "test"}
      assert_equal ["test"], Topic.find(1).team_list
    end

    test "an #{admin} should be able to unassign_team of a topic" do
      Topic.find(1).team_list = "test"
      sign_in users(admin.to_sym)
      xhr :get, :unassign_team, { topic_ids: [1]}
      assert_equal [], Topic.find(1).team_list
    end


    # NOTE: THIS BEHAVIOR WAS REVERSED BASED ON USER FEEDBACK THAT IT WAS HARD TO
    # FIND DISCUSSIONS AFTER THEY WERE VIEWED, LEFT TEST JUST IN CASE
    #
    # test "an #{admin}viewing a new discussion should change the status to PENDING" do
    #   sign_in users(admin.to_sym)
    #   @ticket = Topic.find(6)
    #
    #   xhr :get, :show, { id: @ticket.id }
    #
    #   #reload object:
    #   @ticket = Topic.find(6)
    #   assert @ticket.current_status == "pending", "ticket status did not change to pending"
    # end
  end

  test "an agent that is assigned to a group should only see search topics from that group" do
    sign_in users(:agent)

    # Assign agent and topic to a group
    agent = users(:agent)
    agent.team_list = "test"
    agent.save!

    topic = topics(:private)
    topic.current_status = "open"
    topic.team_list = "test"
    topic.save!

    get :index, { status: "open" }
    assert_not_nil assigns(:topics)
    assert_equal 1, assigns(:topics).size
    assert_template "admin/topics/index"
    assert_response :success
  end

  test "an agent that is assigned to a group should not see topics from another group" do
    sign_in users(:agent)

    # Assign agent and topic to a group
    agent = users(:agent)
    agent.team_list = "test"
    agent.save!

    topic = topics(:private)
    topic.current_status = "open"
    topic.team_list = "aomething else"
    topic.save!
    get :index, { status: "open" }
    assert_equal 0, assigns(:topics).size
    assert_template "admin/topics/index"
    assert_response :success
  end

  test "an agent that is assigned to a group should not be able to view a topic from another group" do
    sign_in users(:agent)

    # Assign agent and topic to a group
    agent = users(:agent)
    agent.team_list = "test"
    agent.save!

    topic = topics(:private)
    topic.current_status = "open"
    topic.team_list = "aomething else"
    topic.save!

    get :show, { id: topic.id }
    assert_template "admin/topics/show"
    assert_response 403
  end

  %w(user editor).each do |unauthorized|

    test "an #{unauthorized} should NOT be able to see a list of topics via standard request" do
      sign_in users(unauthorized.to_sym)

      get :index, { status: "open" }
      assert_nil assigns(:topics)
      assert_response :redirect
    end

    test "an #{unauthorized} should NOT be able to see a specific topic of each type via standard request" do
      sign_in users(unauthorized.to_sym)
      [3,7].each do |topic_id|
        get :show, { id: topic_id }
        assert_nil assigns(:topic)
        assert_response :redirect
      end
    end
  end

  test 'toggle_privacy clear pg search document for private topic' do
    sign_in users(:agent)
    topic = create(:topic, private: false)
    refute_nil topic.pg_search_document
    xhr :get, :toggle_privacy, { topic_ids: [topic.id], private: true, forum_id: 1}
    assert_equal topic.reload.private, true
    assert_nil topic.pg_search_document
  end

  test 'toggle_privacy create pg search document for public topic' do
    sign_in users(:agent)
    topic = create(:topic, private: true)
    topic.reload
    assert_nil topic.pg_search_document
    xhr :get, :toggle_privacy, { topic_ids: [topic.id], private: false, forum_id: 4}
    assert_equal topic.reload.private, false
    refute_nil topic.pg_search_document
  end

  # Test of super bulk (all matching tickets) actions

  test "should be able to move all matching tickets to trash" do
    Topic.find(1).update(current_status: 'spam')
    Topic.find(2).update(current_status: 'spam')
    spam_topics = Topic.where(current_status: 'spam').all
    sign_in users(:agent)
    assert_difference("Topic.trash.size", spam_topics.size) do
      xhr :get, :update_topic, { q: 'spam', change_status: "trash", affect: 'all' }
    end
    assert_response :success
  end

  test "should be able to assign all matching tickets to agent" do
    Topic.find(1).update(current_status: 'spam')

    Topic.where(assigned_user_id: 1).update_all(assigned_user_id: nil)
    spam_topics = Topic.where(current_status: 'spam').all
    sign_in users(:agent)
    assert_difference("Topic.where(assigned_user_id: 1).size", spam_topics.size) do
      xhr :get, :assign_agent, { q: 'spam', assigned_user_id: 1, affect: 'all' }
    end
    assert_response :success
  end

  test "should be able to unassign all matching tickets" do
    Topic.find(1).update(current_status: 'spam')
    Topic.find(2).update(current_status: 'spam')

    Topic.find(1).update(current_status: 'spam')
    spam_topics = Topic.where(current_status: 'spam').all
    sign_in users(:agent)
    xhr :get, :unassign_agent, { q: 'spam', affect: 'all' }
    assert_equal 2, Topic.admin_search('spam').where(assigned_user_id: nil).size
    assert_response :success
  end

  test "should be able to assign all matching tickets to group" do
    Topic.find(1).update(current_status: 'spam')
    Topic.find(2).update(current_status: 'spam')

    spam_topics = Topic.where(current_status: 'spam').all
    sign_in users(:agent)
    assert_difference("Topic.tagged_with('test_team', context: 'teams').size", spam_topics.size) do
      xhr :get, :assign_team, { q: 'spam', assign_team: "test_team", affect: 'all' }
    end
    assert_response :success
  end
  
  test "should be able to unassign all matching tickets from group" do
    sign_in users(:agent)
    Topic.admin_search('new').each do |t|
      t.team_list = 'test_team'
      t.save!
    end
    xhr :get, :unassign_team, { q: 'new', affect: 'all' }
    assert_equal 0, Topic.admin_search('new').tagged_with('test_team', context: 'teams').size
    assert_response :success
  end

end
