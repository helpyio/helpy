require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "a browsing user should get home page" do
    get :index, locale: :en
    assert_response :success
  end

  test "a browsing user should see the correct template when visiting the home page" do
    get :index, locale: :en
    assert_template layout: "layouts/application"
  end

  # There are two categories in the test data, one is featured on home page
  test "a browsing user home page should feature one category" do
    get :index, locale: :en
    assert_not_nil assigns(:categories)
  end

end
