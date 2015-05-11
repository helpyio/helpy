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
    assert_response :success
  end

  test "should be able to see a list of topics via ajax" do
    xhr :get, :tickets, { status: 'open' }, format: :js
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to see a specific topic via standard request" do
    get :ticket, { id: 3 }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  test "should be able to see a specific topic via ajax" do
    xhr :get, :ticket, { id: 3 }
    assert_not_nil assigns(:topic)
    assert_response :success
  end

  ### Assigning topic tests

  test "should be able to assign an unassigned discussion" do
    xhr :get, :assign_agent, { topic_ids: {"":1} }, { assigned_user_id: 1 }
    assert_response :success
  end

  test "should be able to assign a previously assigned discussion" do
    xhr :get, :assign_agent, { topic_ids: {'':3} }, { assigned_user_id: 1 }
    assert_response :success
  end

  test "should be able to assign multiple tickets" do
    xhr :get, :assign_agent, { topic_ids: {'':3,'':2} }, { assigned_user_id: 1 }
    assert_response :success
  end

  test "assigning a discussion to a different agent should create a note" do


  end


  ### Replying to tickets

  test "should be able to reply to a ticket" do

  end

  test "posting an internal note should not send email" do

  end


  ### tests of changing status

  test "posting an internal note should not change status on its own" do

  end

  test "should be able to change an open ticket to closed" do
    xhr :get, :update_ticket, { topic_ids: {'':2} }, { change_status: 'closed' }
    assert_response :success
  end

  test "should be able to change a closed ticket to open" do
    xhr :get, :update_ticket, { topic_ids: {'':3} }, { change_status: 'open' }
    assert_response :success
    assert_template layout: nil
  end

  test "should be able to change an open ticket to spam" do
    xhr :get, :update_ticket, { topic_ids: {'':2} }, { change_status: 'spam' }
    assert_response :success
    assert_template layout: nil
  end

  test "should be able to change the status of multiple topics at once" do
    xhr :get, :update_ticket, { topic_ids: { '':2,'':3 } }, { change_status: 'closed' }
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

  test "should be able to search by topic ID" do
    xhr :get, :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test "should be able to search by user name" do
    xhr :get, :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test "should be able to search by subject" do
    xhr :get, :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

end
