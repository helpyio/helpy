require 'test_helper'

class EmailProcessorTest < ActiveSupport::TestCase

  setup do
    set_default_settings
  end

  test 'an email to the support address from an unknown user should create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_from_unknown)).process
          end
        end
      end
    end
  end

  test 'an email to the support address with no name should create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_from_unknown_name_missing)).process
          end
        end
      end
    end
  end

  test 'an email to the support address with email with numbers should create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_from_known_token_numbers)).process
          end
        end
      end
    end
  end

  test 'an email to the support address sent to multiple addresses create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_to_multiple)).process
          end
        end
      end
    end
  end

  test 'an email to the support address using quotes should create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_to_quoted)).process
          end
        end
      end
    end
  end

  test 'an email with one attachment should save that attachment' do

    assert_difference('Topic.count', 1) do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(build(:email_from_unknown_with_attachments, :with_attachment)).process
      end
    end

    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
    assert_equal 1, Topic.last.posts.first.attachments.count
  end

  test 'an email with multiple attachments should save those attachments' do
    assert_difference('Topic.count', 1) do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(build(:email_from_unknown_with_attachments, :with_multiple_attachments)).process
      end
    end
    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
    assert_equal 2, Topic.last.posts.first.attachments.count
  end

  test 'an email to the support address from a known user should create a new ticket for the user' do
    assert_difference('Topic.count', 1) do
      assert_difference('Post.count', 1) do
          EmailProcessor.new(build(:email_from_known)).process
      end
    end
  end

  test 'a reply to the support address should be added as a reply post to the topic' do
    assert_no_difference('Topic.count') do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(build(:reply)).process
      end
    end
  end

  test 'a user should be able to reply to a ticket by email and the ticket status should change to pending' do
    assert_difference 'Topic.where(current_status: "pending").count', 1 do
      EmailProcessor.new(build(:reply)).process
    end
  end

  test 'a reply to a closed ticket should be added as a reply post to the topic and change the status to pending' do
    assert_difference 'Topic.where(current_status: "pending").count', 1 do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(build(:reply_to_closed_ticket)).process
      end
    end
  end

  test 'an email to the with invalid utf8 should create a new user and topic with status new' do
    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 2) do
            EmailProcessor.new(build(:email_from_unknown_invalid_utf8)).process
          end
        end
      end
    end
  end

  test 'an email with cc should create post containing same cc' do
    email = build(:email_with_cc)
    EmailProcessor.new(email).process
    assert_equal(Post.last.cc, email[:cc].map{|e| e[:full]}.join(", "))
  end
end
