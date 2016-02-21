require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    sign_in users(:admin)
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  ### Topic Views

  test "an admin should be able to see a list of topics via standard request" do
    get :tickets, { status: 'open' }
    assert_not_nil assigns(:topics)
    assert_template 'tickets'
    assert_response :success
  end

  test "an admin should be able to see a list of topics via ajax" do
    xhr :get, :tickets, { status: 'open' }, format: :js
    assert_not_nil assigns(:topics)
    assert_template 'tickets'
    assert_response :success
  end

  test "an admin should be able to see a specific topic of each type via standard request" do
    [3,7].each do |topic_id|
      get :ticket, { id: topic_id }
      assert_not_nil assigns(:topic)
      assert_template 'ticket'
      assert_response :success
    end
  end

  test "an admin should be able to see a specific topic of each type via ajax" do
    [3,7].each do |topic_id|
      xhr :get, :ticket, { id: topic_id }
      assert_not_nil assigns(:topic)
      assert_template 'ticket'
      assert_response :success
    end
  end

  ### Testing User Views

  test "an admin should be able to see a user profile" do
    xhr :get, :user_profile, { id: 2 }
    assert_response :success
    assert_equal(6, assigns(:topics).count)
  end

  test "an admin should be able to edit a user profile" do
    xhr :get, :edit_user, { id: 2 }
    assert_response :success
  end


  ### Assigning topic tests

  test "an admin should be able to assign an unassigned discussion" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { topic_ids: [1], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "an admin should be able to assign a previously assigned discussion" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { topic_ids: [3], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "an admin should be able to assign multiple tickets" do
    assert_difference 'Post.count', 2 do
      xhr :get, :assign_agent, { topic_ids: [3,2], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "an admin assigning a discussion to a different agent should create a note" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { assigned_user_id: 1, topic_ids: [1] }
    end
    assert_response :success
  end


  ### tests of changing status

  test "an admin posting an internal note should not change status on its own" do

  end

  test "an admin should be able to change an open ticket to closed" do
    assert_difference('Post.count') do
      xhr :get, :update_ticket, { topic_ids: [2], change_status: 'closed' }
    end
    assert_response :success
  end

  test "an admin should be able to change a closed ticket to open" do
    assert_difference('Post.count') do
      xhr :get, :update_ticket, { topic_ids: [3], change_status: 'reopen' }
    end
    assert_response :success
    assert_template layout: nil
  end

  test "an admin should be able to change an open ticket to spam" do
    xhr :get, :update_ticket, { topic_ids: [2], change_status: 'spam' }
    assert_response :success
    assert_template layout: nil
  end

  test "an admin should be able to change the status of multiple topics at once" do
    assert_difference('Post.count',2) do
      xhr :get, :update_ticket, { topic_ids: [2,3], change_status: 'closed' }
    end
    assert_response :success
  end

  ### testing new discussion creation and lifecycle

  test "an admin should be able to open a new discussion for a new user" do
    xhr :get, :new_ticket
    assert_response :success
  end


  test "an admin should be able to create a new private discussion for a new user" do

    assert_difference 'Topic.count', 1 do
      assert_difference 'Post.count', 1 do
        assert_difference 'User.count', 1 do
          assert_difference 'ActionMailer::Base.deliveries.size', 1 do
            xhr :post, :create_ticket, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new private topic", body: "some body text", forum_id: 1}, post: {body: 'this is the body'}
          end
        end
      end
    end

  end

  test "an admin should be able to create a new private discussion for an existing user" do

    assert_difference 'Topic.count', 1 do
      assert_difference 'Post.count', 1 do
        assert_no_difference 'User.count' do
          assert_difference 'ActionMailer::Base.deliveries.size', 1 do
            xhr :post, :create_ticket, topic: { user: {name: 'Scott Smith', email: 'scott.smith@test.com'}, name: "some new private topic", body: "some body text", forum_id: 1}, post: {body: 'this is the body'}
          end
        end
      end
    end

  end

  test "an admin viewing a new discussion should change the status to PENDING" do
    @ticket = Topic.find(6)

    xhr :get, :ticket, {id: @ticket.id }

    #reload object:
    @ticket = Topic.find(6)
    assert @ticket.current_status == "pending", "ticket status did not change to pending"
  end

  # User/Admin reply tests are in posts_controller_test

  test "a user replying to a discussion should change the status to PENDING" do
    @ticket = Topic.find(6)


  end

  test "an admin replying to a discussion should change the status to OPEN" do

  end

  ### Test search function

  test "an admin should be able to search by topic ID by ajax" do
    xhr :get, :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "an admin should be able to search by user name by ajax" do
    xhr :get, :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "an admin should be able to search by subject by ajax" do
    xhr :get, :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "an admin should be able to search for users with multiple matches via ajax" do
    xhr :get, :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(3, assigns(:users).size)
    assert_response :success
  end

  test "an admin should be able to search by topic ID" do
    get :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "an admin should be able to search by user name" do
    get :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "an admin should be able to search by subject" do
    get :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "an admin should be able to search for users with multiple matches" do
    get :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(3, assigns(:users).size)
    assert_response :success
  end

  test "an admin should be able to reorder docs" do
    post :update_order, object: 'doc', obj_id: 4, row_order_position: 0
    assert_equal Doc.order('rank asc').first.id, 4
  end

  test "an admin should be able to reorder categories" do
    post :update_order, object: 'category', obj_id: 4, row_order_position: 0
    assert_equal Category.order('rank asc').first.id, 4
  end

end
