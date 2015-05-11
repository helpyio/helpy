require 'test_helper'

class ResultControllerTest < ActionController::TestCase

  def setup

    # Build PG search
    PgSearch::Multisearch.rebuild(Doc)
    PgSearch::Multisearch.rebuild(Topic)

  end


  test "searching for a doc should return a result" do

    get(:index, { q: 'article1 text' })
    assert_not_nil assigns(:results)
    assert_equal(1, assigns(:results).total_count)
    assert_response :success
  end

  test "searching for something not in search should not return a result" do
    get(:index, { q: 'somethingnotinsearch' })
    assert_not_nil assigns(:results)
    assert_equal(0, assigns(:results).total_count)
    assert_response :success
  end

  test "searching for a topic should return a result" do
    get(:index, { q: 'This is a public post' })
    assert_not_nil assigns(:results)
    assert_equal(1, assigns(:results).total_count, "Did not find results for the search")
    assert_response :success
  end

  test "searching for a private topic should not return a result" do
    get(:index, { q: 'This is a private post' })
    assert_not_nil assigns(:results)
    assert_equal(0, assigns(:results).total_count, "Found a result when searching for a private topic")
    assert_response :success
  end

  test "adding a public topic should add it to search" do

    @topic = Topic.create(forum_id: 3, user_id: 1, name: "My new post")
    @post = Post.create(topic_id: @topic.id, user_id: 1, body: "This is something amazing", kind: "first")

    # have to manually rebuild search
    PgSearch::Multisearch.rebuild(Topic)

    get(:index, { q: 'This is something amazing' })
    assert_not_nil assigns(:results)
    assert_equal(1, assigns(:results).total_count, "Did not find results for the search")
    assert_response :success

  end

  test "adding a private topic should NOT add it to search" do

    @topic = Topic.create(forum_id: 1, user_id: 1, name: "My new private post", private: true)
    @post = Post.create(topic_id: @topic.id, user_id: 1, body: "This is something private", kind: "first")

    # have to manually rebuild search
    PgSearch::Multisearch.rebuild(Topic)

    get(:index, { q: 'This is something private' })
    assert_equal(0, assigns(:results).total_count, "Found results for the search when shouldn't have")
    assert_response :success

  end


end
