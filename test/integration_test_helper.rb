require "test_helper"
require "capybara/rails"
require "capybara/poltergeist"

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  Capybara.javascript_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app,
      js_errors: false,
      window_size: [1200, 1000],
      phantomjs_logger: 'fake',
      timeout: 15
    )
  end
end

def sign_in(email='scott.miller@test.com')
  visit "/en/users/sign_in"
  sleep(1)
  within first('div.login-form') do
    fill_in("user[email]", with: email)
    fill_in("user[password]", with: '12345678')
    click_button('Sign in')
  end
end

def sign_in_by_modal(email='scott.miller@test.com')
  visit('/')
  within("div#above-header") do
    click_on "Sign in", wait: 30
  end
  within('div#login-modal') do
    fill_in("user[email]", with: email)
    fill_in("user[password]", with: '12345678')
    click_on('Sign in')
  end
end

def sign_out
  logout(:user)
  sleep(3)
end

def click_logout
  sleep(2)
  find('a.navbar-brand').click
  sleep(2)
  within("div#above-header") do
    click_on("Logout")
  end
  sleep(3)
end

def create_discussion
  click_on "New Discussion"
  sleep(2)
  fill_in("topic_user_email", with: "scott.smith@test.com")
  fill_in("topic_user_name", with: "Scott Smith")
  fill_in("topic_name", with: "New test message from admin form")
  fill_in("post_body", with: "This is the message")
  sleep(1)
  find(".submit-start-discussion").click
end
