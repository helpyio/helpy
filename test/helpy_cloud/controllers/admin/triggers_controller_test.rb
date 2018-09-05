require 'test_helper'

class Admin::TriggersControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a signed out user should not be able to load the triggers page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load the triggers page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to root_path
  end

  test "an admin should be able to load the triggers page" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

  test "an admin should be able to create new triggers with one action" do
    sign_in users(:admin)
    params = {
      trigger: {
        event: "ticket_created",
        mode: 'and',
        slack_channel: '',
        url: ''
      },
      conditions: [],
      operators: [],
      values: [],
      actions: ["resolve"],
      action_values: []
    }
    assert_difference "Trigger.count", 1 do
      post :create, params
    end
    assert_equal 1, Trigger.last.actions.count
    assert_equal "ticket_created", Trigger.last.event
  end

  test "an admin should be able to create new triggers with conditions and multiple actions" do
    sign_in users(:admin)
    params = {
      trigger: {
        event: "ticket_created",
        mode: 'and',
        slack_channel: '',
        url: ''
      },
      conditions: ["name, test", "channel, email"],
      operators: [],
      values: [],
      actions: ["resolve","internal_note, this is it"],
      action_values: []
    }
    assert_difference "Trigger.count", 1 do
      post :create, params
    end
    assert_equal 2, Trigger.last.actions.count
    assert_equal 2, Trigger.last.conditions.count
  end

  test "an admin should be able to delete triggers" do
    sign_in users(:admin)
    trigger = Trigger.create(event: 'assigned_agent')
    assert_difference "Trigger.count", -1 do
      xhr :delete, :destroy, { id: trigger.id, locale: "en" }
    end
  end

  test "an admin should be able to update triggers" do
    sign_in users(:admin)
    trigger = Trigger.create!(
      event: "ticket_created",
      mode: 'and',
      slack_channel: '',
      url: '',
      conditions: ["name, test", "channel, email"],
      actions: ["resolve,","internal_note, this is it"]
    )

    # Update params
    params = {
      id: Trigger.last.id,
      trigger: {
        event: "ticket_created",
        mode: 'and',
        slack_channel: '',
        url: ''
      },
      conditions: [""],
      operators: [""],
      values: [""],
      actions: ["resolve"],
      action_values: [""]
    }
    put :update, params
    assert_equal 1, Trigger.last.actions.count
    assert_equal 1, Trigger.last.conditions.count
  end

end
