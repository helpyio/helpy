require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get home page" do
    get :index
    assert_response :success
  end

  test "index should render correct template" do
    get :index
    assert_template layout: "layouts/application"
  end

  # There are two categories in the test data, one is featured on home page
  test "home page should feature one category" do
    get :index
    assert_not_nil assigns(:categories)
  end

end
