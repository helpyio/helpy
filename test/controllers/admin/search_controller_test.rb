require "test_helper"

class Admin::SearchControllerTest < ActionController::TestCase

  setup do
  end

  %w(user editor).each do |unauthorized|
    test "an #{unauthorized} should not be able to search" do
      sign_in users(unauthorized.to_sym)
      get :topic_search, q: "1"
      assert_nil assigns(:topics)
      assert_response :redirect
    end
  end

  %w(admin agent).each do |admin|
    test "an #{admin} should be able to search by topic ID by ajax" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "1"
      assert_not_nil assigns(:topics)
      assert_response :success
    end

    test "an #{admin} should be able to search by user name by ajax" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "Admin User"
      assert_not_nil assigns(:user)
      assert_response :success
    end

    test "an #{admin} should be able to search by subject by ajax" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "Pending private topic"
      assert_not_nil assigns(:topics)
      assert_response :success
    end

    test "an #{admin} should be able to search for users with multiple matches via ajax" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "scott"
      assert_nil assigns(:topics)
      assert_not_nil assigns(:users)
      assert_equal(3, assigns(:users).size)
      assert_response :success
    end

    test "an #{admin} should be able to search by topic ID" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "1"
      assert_not_nil assigns(:topics)
      assert_response :success
    end

    test "an #{admin} should be able to search by user name" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "Admin User"
      assert_not_nil assigns(:user)
      assert_response :success
    end

    test "an #{admin} should be able to search by subject" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "Pending private topic"
      assert_not_nil assigns(:topics)
      assert_response :success
    end

    test "an #{admin} should be able to search by team" do
      t = Topic.first
      t.team_list = "red team"
      t.save!

      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "red team"
      assert_not_nil assigns(:topics)
      assert_equal ["red team"], assigns(:topics).first.team_list
      assert_response :success
    end

    test "an #{admin} should be able to narrow search by a date range" do
      t = Topic.first
      t.created_at = Time.now - 30.days
      t.save!

      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "private post", start_date: Time.now-31.days, end_date: Time.now - 1.day
      assert_not_nil assigns(:topics)
      assert_equal 1, assigns(:topics).count
      assert_response :success
    end

    test "an #{admin} should be able to search for users with multiple matches" do
      sign_in users(admin.to_sym)
      xhr :get, :topic_search, q: "scott"
      assert_nil assigns(:topics)
      assert_not_nil assigns(:users)
      assert_equal(3, assigns(:users).size)
      assert_response :success
    end
  end

  test "an agent that is assigned to a group should only see search results from that group" do
    sign_in users(:agent)

    # Assign agent and topic to a group
    agent = users(:agent)
    agent.team_list = "test"
    agent.save!
    topic = topics(:private)
    topic.team_list = "test"
    topic.save!

    xhr :get, :topic_search, q: "private"
    assert_not_nil assigns(:topics)
    assert_equal 1, assigns(:topics).size
    assert_equal "test", assigns(:topics).first.team_list[0]
    assert_response :success
  end

end
