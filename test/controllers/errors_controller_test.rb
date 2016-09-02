require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get not_found" do
    get :not_found
    assert_response :missing
  end

  test "should get internal_server_error" do
    get :internal_server_error
    assert_response :error
  end

end
