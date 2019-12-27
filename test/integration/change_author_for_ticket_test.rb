require 'integration_test_helper'

include Warden::Test::Helpers

class ChangeAuthorForTicketTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :chrome
    Warden.test_mode!
    set_default_settings
    sign_in('admin@test.com')
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
    Capybara.use_default_driver
  end

  test 'change author who not email address for existing ticket, helpy will generate a temporary email placeholder from this modal. ' do
    visit '/admin/topics/'
    #find('#modal').native.send_keys(:escape)
    click_link '#7- New Question'
    find('.fa-ellipsis-v').click
    within("ul.dropdown-menu") do
      click_link 'Change author'
    end
    within('.modal-content') do
      fill_in('user_search', with: 'weird_name')
      assert page.has_content?("No Matching Users Found.")
      click_link 'Create New User'
      click_link 'generate temporary'
      fill_in('user_name', with: 'frankenk')
      find('input[name="commit"]').click
    end
    assert page.has_content?('The creator of this topic was changed from Admin User to frankenk')
  end
end


