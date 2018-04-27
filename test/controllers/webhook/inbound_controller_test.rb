require 'test_helper'

class Webhook::InboundControllerTest < ActionController::TestCase

  setup do
    set_default_settings

    @data = {
        "message": {
            "kind": "ticket",
            "subject": "Need Help",
            "body": "I need help with my purchase.",
            "channel": "web",
            "tags": "hello, hi",
            "priority": "high"
        },
        "customer": {
            "fullName": "Bob Doe",
            "emailAddress": "bob@example.com",
            "work_phone": "(555) 555-5555",
            "home_phone": "(555) 555-5555",
            "city": "Palo Alto",
            "region": "CA",
            "country": "United States",
            "countryCode": "US",
            "company": "Widgets Inc."
        }
    }

  end

  test 'a request without a valid token should be rejected' do
    # Enable webhooks
    AppSettings["webhook.form_key"] = SecureRandom.hex
    AppSettings["webhook.form_enabled"] = '1'

    assert_difference 'Topic.count', 0, 'A topic should NOT have been created' do
      assert_difference 'Post.count', 0, 'A post should NOT have been created' do
        post :form, token: 'something else', data: @data.to_json
      end
    end
  end

  test 'should create a new ticket and post when a json webhook is received' do
    # Enable webhooks
    AppSettings["webhook.form_key"] = SecureRandom.hex
    AppSettings["webhook.form_enabled"] = '1'

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :form, token: AppSettings["webhook.form_key"], data: @data.to_json
        assert_equal 2, Topic.last.tag_list.count
        assert_equal true, Topic.last.tag_list.include?("hi")
      end
    end
  end

  test 'should NOT create a new ticket and post when webhooks are disabled' do
    # Disable webhooks
    AppSettings["webhook.form_key"] = SecureRandom.hex
    AppSettings["webhook.form_enabled"] = '0'

    assert_difference 'Topic.count', 0, 'A topic should NOT have been created' do
      assert_difference 'Post.count', 0, 'A post should NOT have been created' do
        post :form, token: AppSettings["webhook.form_key"], data: @data.to_json
      end
    end
  end

end
