require 'integration_test_helper'
include Warden::Test::Helpers

class SignedInUserDocFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :es, :de, :fr, :et, :ca, :ru, :ja, 'zh-cn', 'zh-tw', 'pt', :nl]
    I18n.locale = :en

    sign_in('admin@test.com')
  end

  def teardown
    Warden.test_reset!
  end

  test "an admin should be able to modify site settings and see those changes on the support site" do

    click_on 'Settings'

    assert page.has_content?("Settings")


    
  end


end
