# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#  doc_id           :integer          default(0)
#  channel          :string           default("email")
#  kind             :string           default("ticket")
#  priority         :integer          default(1)
#

require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a user creating a new ticket should cause the triggers to fire" do
    AppSettings['settings.tickets'] = "1"

    # sign_in users(:user)

    create_triggers

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      assert_difference 'Post.count', 2, "A post should have been created" do
          # TODO: refactor this into a method and DRY up tests

          post :create,
            topic: {
              user: {
                name: 'a user',
                email: 'anon@test.com'
              },
              name: "some new public topic",
              body: "some body text",
              forum_id: 1,
              private: true,
              posts_attributes: {
                :"0" => {
                  body: "this is the body"
                }
              }
            },
            locale: :en
      end
    end
    assert_not_nil Topic.last.assigned_user_id
    assert_redirected_to topic_thanks_path, "Did not redirect to thanks view"
  end

  # Test presence of extra fields on the new ticket form
  test "extra fields should be shown on the create ticket form" do
    # Add extra fields
    field = TopicField.create!(name: 'blah', label: 'Favorite Food', field_type: "text", display_on_helpcenter: true)
    # load form and assert their presence
    get :new, locale: :en
    assert_select "#topic_#{field.name}"
  end

  # Test presence of extra fields on the new ticket form
  test "extra fields should be stored as kv attributes for the topic" do
    # Add extra fields
    field = TopicField.create!(name: 'blah', label: 'Favorite Food', field_type: "text", display_on_helpcenter: true)

    # load form and assert their presence
    assert_difference 'KeyValue.count', 1, "Attribute was not stored" do
      assert_difference 'Topic.count', 1, "A topic should have been created" do
        # assert_difference 'Post.count', 2, "A post should have been created" do

        post :create,
          topic: {
            user: {
              name: 'a user',
              email: 'anon@test.com'
            },
            name: "some new public topic",
            blah: "something",
            forum_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
                body: "this is the body"
              }
            }
          },
          locale: :en
        # end
      end
    end

    assert_equal "something", KeyValue.last.value
  end

  def create_triggers
    Trigger.create!(
      event: 'ticket_created',
      conditions: ['name_cont, topic'],
      actions: ['any_agent,'],
      mode: 'and'

    )
  end

end
