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
    # binding.pry
    assert_not_nil Topic.last.assigned_user_id
    assert_redirected_to topic_thanks_path, "Did not redirect to thanks view"
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
