require 'test_helper'

class RatingControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    @controller = RatingsController.new
  end

  test "browsing user should be able to load the rating page" do
    get :new, topic_id: Topic.first.hashed_id, locale: :en
    assert :success
  end

  test "should save the rating score if its provided in the params" do
    assert_difference 'Rating.count', +1 do
      get :new, topic_id: Topic.first.hashed_id, score: 3, locale: :en
    end
  end

  test "should be able to create a new rating" do
    assert_difference 'Rating.count', +1 do
      post :create, topic_id: Topic.first.id, locale: :en, rating: {
        user_id: 1, score: 2, comments: 'blah blah blah'
      }
    end
    assert_equal 2, Topic.first.rating.score
    assert_equal "blah blah blah", Topic.first.rating.comments
    assert_redirected_to rating_thanks_path
  end
end
