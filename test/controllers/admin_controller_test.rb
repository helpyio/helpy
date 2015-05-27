require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    sign_in users(:admin)
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
  end

  ### Topic Views

  test "should be able to see a list of topics via standard request" do
    get :tickets, { status: 'open' }
    assert_not_nil assigns(:topics)
    assert_template 'tickets'
    assert_response :success
  end

  test "should be able to see a list of topics via ajax" do
    xhr :get, :tickets, { status: 'open' }, format: :js
    assert_not_nil assigns(:topics)
    assert_template 'tickets'
    assert_response :success
  end

  test "should be able to see a specific topic via standard request" do
    get :ticket, { id: 3 }
    assert_not_nil assigns(:topic)
    assert_template 'ticket'
    assert_response :success
  end

  test "should be able to see a specific topic via ajax" do
    xhr :get, :ticket, { id: 3 }
    assert_not_nil assigns(:topic)
    assert_template 'ticket'
    assert_response :success
  end

  ### Testing User Views

  test "should be able to see a user profile" do
    xhr :get, :user_profile, { id: 2 }
    assert_response :success
    assert_equal(3, assigns(:topics).count)
  end

  test "should be able to edit a user profile" do

  end

  ### Assigning topic tests

  test "should be able to assign an unassigned discussion" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { topic_ids: [1], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "should be able to assign a previously assigned discussion" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { topic_ids: [3], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "should be able to assign multiple tickets" do
    assert_difference 'Post.count', 2 do
      xhr :get, :assign_agent, { topic_ids: [3,2], assigned_user_id: 1 }
    end
    assert_response :success
  end

  test "assigning a discussion to a different agent should create a note" do
    assert_difference 'Post.count', 1 do
      xhr :get, :assign_agent, { assigned_user_id: 1, topic_ids: [1] }
    end
    assert_response :success
  end


  ### tests of changing status

  test "posting an internal note should not change status on its own" do

  end

  test "should be able to change an open ticket to closed" do
    xhr :get, :update_ticket, { topic_ids: [2], change_status: 'closed' }
    assert_response :success
  end

  test "should be able to change a closed ticket to open" do
    xhr :get, :update_ticket, { topic_ids: [3], change_status: 'open' }
    assert_response :success
    assert_template layout: nil
  end

  test "should be able to change an open ticket to spam" do
    xhr :get, :update_ticket, { topic_ids: [2], change_status: 'spam' }
    assert_response :success
    assert_template layout: nil
  end

  test "should be able to change the status of multiple topics at once" do
    xhr :get, :update_ticket, { topic_ids: [2,3], change_status: 'closed' }
    assert_response :success
  end

  ### testing new discussion creation and lifecycle

  test "should be able to open a new discussion for a new user" do

  end

  test "should be able to open a new discussion for an existing user" do

  end

  test "a new discussion should have status of NEW" do

  end

  test "viewing a new discussion should change the status to OPEN" do

  end

  test "a CLOSED message should not be assigned to an agent" do

  end


  ### Test search function

  test "should be able to search by topic ID by ajax" do
    xhr :get, :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to search by user name by ajax" do
    xhr :get, :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "should be able to search by subject by ajax" do
    xhr :get, :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to search for users with multiple matches via ajax" do
    xhr :get, :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(2, assigns(:users).size)
    assert_response :success
  end

  test "should be able to search by topic ID" do
    get :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to search by user name" do
    get :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "should be able to search by subject" do
    get :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to search for users with multiple matches" do
    get :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(2, assigns(:users).size)
    assert_response :success
  end

end
