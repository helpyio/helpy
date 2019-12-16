require 'test_helper'

class Admin::ReportsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test 'activity report should render successfully' do
    get :index, locale: :en
    assert_response :success
  end

  test 'team insights report should render successfully' do
    get :team, locale: :en
    assert_response :success
  end

  test 'groups report should render successfully' do
    get :groups, locale: :en
    assert_response :success
  end

  test 'tag report should render successfully' do
    get :tags, locale: :en
    assert_response :success
  end

  test 'group report should render successfully' do

    # create group and assign topic to it
    @group = ActsAsTaggableOn::Tag.create(
      name: 'test',
      show_on_helpcenter: true,
      show_on_admin: true,
      show_on_dashboard: true
    )
    # Topic.first.team_list(@group.name).save

    get :group, locale: :en, group: 'test'
    assert_response :success
  end

  test 'agents report should render successfully' do
    get :agents, locale: :en
    assert_response :success
  end

  test 'agent report should render successfully' do
    get :agent, locale: :en, id: 1
    assert_response :success
  end

  test 'channels report should render successfully' do
    get :channels, locale: :en
    assert_response :success
  end

  test 'satisfaction report should render successfully' do
    get :satisfaction, locale: :en
    assert_response :success
  end

  test 'productivity report should render successfully' do
    get :productivity, locale: :en
    assert_response :success
  end

  test 'docs report should render successfully' do
    get :docs, locale: :en
    assert_response :success
  end

  test 'cats report should render successfully' do
    get :cats, locale: :en
    assert_response :success
  end

  test 'search report should render successfully' do
    get :searches, locale: :en
    assert_response :success
  end

end
