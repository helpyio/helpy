require "test_helper"

class Admin::TopicsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
    set_default_settings
  end

  %w(admin agent).each do |admin|

    ### Topic Views

    test "an #{admin} should be able to see a list of topics via standard request" do
      sign_in users(admin.to_sym)

      get :index, { status: "open" }
      assert_not_nil assigns(:topics)
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

    ### testing new discussion creation and lifecycle

    test "an #{admin} should be able to open a new discussion for a new user" do
      sign_in users(admin.to_sym)
      xhr :get, :new
      assert_response :success
    end

    test "an #{admin} should be able to create a new private discussion for a new user" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_difference "User.count", 1 do
            assert_difference "ActionMailer::Base.deliveries.size", 1 do
              xhr :post, :create, topic: { user: { name: "a user", email: "anon@test.com" }, name: "some new private topic", post: { body: "this is the body" }, forum_id: 1 }
            end
          end
        end
      end
    end

    test "an #{admin} should be able to create a new private discussion for an existing user" do
      sign_in users(admin.to_sym)
      assert_difference "Topic.count", 1 do
        assert_difference "Post.count", 1 do
          assert_no_difference "User.count" do
            assert_difference "ActionMailer::Base.deliveries.size", 1 do
              xhr :post, :create, topic: { user: { name: "Scott Smith", email: "scott.smith@test.com" }, name: "some new private topic", post: { body: "this is the body" }, forum_id: 1 }
            end
          end
        end
      end
    end

    test "an #{admin}viewing a new discussion should change the status to PENDING" do
      sign_in users(admin.to_sym)
      @ticket = Topic.find(6)

      xhr :get, :show, { id: @ticket.id }

      #reload object:
      @ticket = Topic.find(6)
      assert @ticket.current_status == "pending", "ticket status did not change to pending"
    end
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

end
