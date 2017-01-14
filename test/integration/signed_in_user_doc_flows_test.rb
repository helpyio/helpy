require 'integration_test_helper'

include Warden::Test::Helpers

class SignedInUserDocFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    set_default_settings

    sign_in
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test "when a doc allows commenting and there are comments, a signed in user should see comments and a reply form" do

    create_some_comments
    visit '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments'
    assert page.has_content?('test post')
    assert page.has_content?('Reply')
    assert page.has_css?("div.add-form")

    fill_in('post_body', with: "Added a comment!")
    click_on('Post Reply', disabled: true)

    assert page.has_content?('Added a comment!')

    clear_comments
  end

  test "when a doc allows commenting and there are no comments, a signed in user should see a start discussion form" do

    visit '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments'
    assert page.has_content?('Start a Discussion')
    assert page.has_css?("div.add-form")

    fill_in('post_body', with: "Added a comment!")
    click_on('Start a Discussion', disabled: true)

    assert page.has_content?('Added a comment!')

  end

  test "when a doc does not allow commenting, a signed in user should not see a reply or start discussion button" do

    visit '/en/knowledgebase/1-active-and-featured/docs/5-does-not-allow-comments'
    assert page.has_no_content?('Start a New Discussion')
    assert page.has_no_content?('Reply')
    assert page.has_no_css?("div.add-form")

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
