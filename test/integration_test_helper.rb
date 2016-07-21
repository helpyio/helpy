require 'test_helper'
require "capybara/rails"

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

def sign_in(email='scott.miller@test.com')
  visit "/en/users/sign_in"
  within first('div.login-form') do
    fill_in("user[email]", with: email)
    fill_in("user[password]", with: '12345678')
    click_on('Sign in')
  end
end

def sign_out
  logout(:user)
end
