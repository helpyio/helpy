require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  setup do
    set_default_settings
  end

  # GET #index
  %w(agent admin).each do |user|
    test "a(n) #{user} should redirect" do
      sign_in users(user.to_sym)
      get :index, locale: :en
      assert_redirected_to admin_topics_path
    end
  end

  test 'an editor should redirect' do
    sign_in users(:editor)
    get :index, locale: :en
    assert_redirected_to admin_categories_path
  end

  # GET #stats
  test 'an admin should get stats' do
    sign_in users(:admin)
    get :stats, locale: :en
    assert_response :success
  end

  %w(agent editor user).each do |unauthorized_user|
    test "a(n) #{unauthorized_user} should not get stats" do
      sign_in users(unauthorized_user.to_sym)
      get :stats, locale: :en
      assert_redirected_to root_path
    end
  end

  test 'sets @interval correctly' do
    sign_in users(:admin)
    get :stats, locale: :en, start_date: Time.zone.today.midnight.at_beginning_of_month, end_date: Time.zone.today.midnight.at_end_of_month, label: 'this_month'
    assert_equal 'This month', assigns(:interval)
  end

  test 'sets @topics correctly'
  test 'sets @responded_topics correctly'
  test 'sets @posts correctly'
  test 'sets @median_first_response_time correctly'
  test 'sets @agents correctly'
  test 'sets @cols correctly'
  test 'sets @agents_stats correctly'
end
