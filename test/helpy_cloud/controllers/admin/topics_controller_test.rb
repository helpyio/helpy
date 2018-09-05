require "test_helper"

class Admin::TopicsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
    set_default_settings
  end

  %w(admin agent).each do |admin|

    test "the #{admin} UI should display boxes if they are defined" do

      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      # make sure box got built
      assert_equal 1, Box.count

      sign_in users(admin.to_sym)
      get :index

      # assert presnce of boxes

      # assert_select "div#pipeline-wrapper"
      # assert_select "div.pipeline-box"
      # assert_select "span.label.label-t", "test box"

    end

    test "an #{admin} should be able to display boxes with a box ID" do
      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      sign_in users(admin.to_sym)
      get :index, { box_id: box.id }
      assert_response :success
    end

    test "an #{admin} should see the default box by default" do
      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: false
      )
      default = Box.create(
        label: "default box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      sign_in users(admin.to_sym)
      get :index
      assert_response :success
      # assert_select "span.label.label-d", "default box"
    end

  end

end
