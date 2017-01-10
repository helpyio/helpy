require 'integration_test_helper'

include Warden::Test::Helpers

class BrowsingUserDocFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    logout(:user)
    set_default_settings
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test "when a doc allows commenting and there are comments, a browsing user should see comments and a reply button" do
    create_some_comments
    visit '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments'
    assert page.has_content?('test post')
    assert page.has_content?('Reply')

    click_on "Reply"
    assert find("div#login-modal").visible?

    clear_comments
  end

  test "when a doc allows commenting and there are no comments, a browsing user should see a start discussion button" do
    visit '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments'
    assert page.has_content?('Start a Discussion')

    click_on "Start a Discussion"
    assert find("div#login-modal").visible?
  end

  test "when a doc does not allow commenting, a browsing user should not see a reply button" do
    visit '/en/knowledgebase/1-active-and-featured/docs/5-does-not-allow-comments'
    assert page.has_no_content?('Start a New Discussion')
  end

  def create_some_comments
    @doc = Doc.find(6)
    @topic = Topic.create!(
      name: 'Comments on Allows Comments',
      user_id: 1,
      doc_id: @doc.id,
      forum_id: Forum.for_docs.first.id
    )
    @topic.posts.create!(
      body: 'test post',
      user_id: 1,
      kind: 'first'
    )
    @topic.posts.create!(
      body: 'test post 2',
      user_id: 2,
      kind: 'reply'
    )
  end

  def clear_comments
    Topic.where(doc_id: 6).first.destroy!
  end

end
