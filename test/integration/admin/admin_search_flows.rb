require 'integration_test_helper'
include Warden::Test::Helpers

class AdminSearchFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in("admin@test.com")
  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "an admin should be able to search for tickets by number to jump directly to that ticket" do
    fill_in('q', with: '4')
    execute_script "$('form.navbar-form.navbar-right').submit()"
    sleep(1)
    assert page.has_content?("#4- Public topic")
  end

  test "an admin should be able to search for a user by name and see multiple results" do
    fill_in('q', with: 'scott')
    execute_script "$('form.navbar-form.navbar-right').submit()"
    sleep(1)
    assert page.has_content?("3 users were found named Scott:")
  end

  test "an admin should be able to search for a user by exact name and be taken to their profile" do
    fill_in('q', with: 'scott smith')
    execute_script "$('form.navbar-form.navbar-right').submit()"
    sleep(1)
    assert page.has_content?("SCOTT SMITH (EDIT)")
  end

  test "an admin should be able to search for a ticket status and see a list of tickets in that status" do
    fill_in('q', with: 'closed')
    execute_script "$('form.navbar-form.navbar-right').submit()"
    sleep(1)
    assert page.has_content?("#3- Closed private topic")
  end

end
