require "test_helper"

class Admin::TopicsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers["Accepts"] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
    set_default_settings
  end

  %w(admin agent).each do |admin|

    test "the #{admin} UI should display boxes if they are defined" do

      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      # make sure box got built
      assert_equal 1, Box.count

      sign_in users(admin.to_sym)
      get :index

      # assert presnce of boxes

      # assert_select "div#pipeline-wrapper"
      # assert_select "div.pipeline-box"
      # assert_select "span.label.label-t", "test box"

    end

    test "an #{admin} should be able to display boxes with a box ID" do
      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      sign_in users(admin.to_sym)
      get :index, { box_id: box.id }
      assert_response :success
    end

    test "an #{admin} should see the default box by default" do
      box = Box.create(
        label: "test box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: false
      )
      default = Box.create(
        label: "default box",
        description: "this is the description",
        query:'{"user_email_cont"=>""}',
        default: true
      )

      sign_in users(admin.to_sym)
      get :index
      assert_response :success
      # assert_select "span.label.label-d", "default box"
    end
    # Testing sending an auto response email by trigger, including CC and BCC
    test "a #{admin} creating a new ticket should cause the triggers to send an autoresponse" do
      AppSettings['settings.tickets'] = "1"

      sign_in users(admin.to_sym)
      create_auto_respond_trigger

      get :new, locale: :en
      assert_response :success
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        xhr :post, :create,
          topic: {
            user: { name: "a user", work_phone: '34526668', email: "change@me-34526668.com" },
            name: "some new private topic",
            post: { body: "this is the body", cc: "cc@test.com", bcc: "bcc@test.com", kind: 'first' },
            channel: "phone",
            forum_id: 1,
            current_status: 'new',
            assigned_user_id: 1
          }
      end
      assert_equal 2, Topic.last.posts.count
      assert_equal "Thanks for contacting us!", Post.last.body
      assert_equal "cc@test.com", Post.last.cc
      assert_equal "bcc@test.com", Post.last.bcc
    end

    # Test presence of extra fields on the new ticket form
    test "#{admin} should be shown extra fields on the admin create ticket form" do
      sign_in users(admin.to_sym)

      # Add extra fields
      field = TopicField.create!(name: 'blah', label: 'Favorite Food', field_type: "text", display_on_admin: true)
      # load form and assert their presence
      get :new, locale: :en
      assert_select "#topic_#{field.name}"
    end

    # Test presence of extra fields on the new ticket form
    test "#{admin} submitting extra fields should be stored as kv attributes for the topic" do
      sign_in users(admin.to_sym)

      # Add extra fields
      field = TopicField.create!(name: 'blah', label: 'Favorite Food', field_type: "text", display_on_admin: true)

      # load form and assert their presence
      assert_difference 'KeyValue.count', 1, "Attribute was not stored" do
        assert_difference 'Topic.count', 1, "A topic should have been created" do
          # assert_difference 'Post.count', 2, "A post should have been created" do

          xhr :post, :create,
            topic: {
              user: { name: "a user", email: "anon@test.com" },
              name: "some new private topic",
              blah: "something",
              post: { body: "this is the body", kind: 'first' },
              forum_id: 1,
              current_status: 'new'
            }
        end
      end

      assert_equal "something", KeyValue.last.value
    end
  end

  def create_auto_respond_trigger
    Trigger.create!(
      event: 'ticket_created',
      conditions: [],
      actions: ['post_reply,Thanks for contacting us!'],
      mode: 'and'
    )
  end
end
