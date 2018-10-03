require 'test_helper'

class Admin::SlasControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test "Should be able to add a SLA" do
    assert_difference 'Sla.count', 1 do
      post :create, sla: { name: '1 hour response', time: '1', time_units: '60' }
    end
  end

  test "Should be able to update a SLA" do
    create_sla

    put :update, id: @sla.id,  sla: { active: false }
    assert_equal false, Sla.last.active
  end

  test "Should be able to delete a SLA" do
    create_sla

    assert_difference 'Sla.count', -1 do
      xhr :delete, :destroy, id: @sla.id
    end
  end

  def create_sla
    @sla = Sla.create!(
      name: '1 hour response',
      description: 'Respons within 1 hour',
      event: 'last_response',
      time: 1,
      time_units: 60,
      tags: 'violation',
      active: true
    )
  end

end
