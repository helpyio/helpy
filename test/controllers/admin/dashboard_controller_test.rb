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

  %w(today yesterday this_week this_month).each do |label|
    test "sets @interval for #{label} correctly" do
      sign_in users(:admin)
      get :stats, locale: :en, label: label
      assert_equal I18n.t(label), assigns(:interval)
    end
  end

  test "@interval defaults to 'This week'" do
    sign_in users(:admin)
    get :stats, locale: :en, label: 'should_default_to_this_week'
    assert_equal I18n.t('this_week'), assigns(:interval)
  end

  test "@start_date default to start of week" do
    sign_in users(:admin)
    get :stats, locale: :en, label: 'should_default_to_this_week'
    assert_equal Time.zone.today.at_beginning_of_week, assigns(:start_date)
  end

  test "@end_date defaults to today at end of day" do
    sign_in users(:admin)
    get :stats, locale: :en, label: 'should_default_to_this_week'
    assert_equal Time.zone.today.at_end_of_day, assigns(:end_date)
  end
end
