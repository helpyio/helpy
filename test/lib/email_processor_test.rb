require 'test_helper'

class EmailProcessorTest < ActiveSupport::TestCase


  test "an email to the support address from an unknown user should create a new user and topic with status new" do

    assert_difference('Topic.where(current_status: "new").count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('ActionMailer::Base.deliveries.size', 1) do
            EmailProcessor.new(FactoryGirl.build(:email_from_unknown)).process
          end
        end
      end
    end

  end

  test "an email to the support address from a known user should create a new ticket for the user" do

    assert_difference('Topic.count', 1) do
      assert_difference('Post.count', 1) do
          EmailProcessor.new(FactoryGirl.build(:email_from_known)).process
      end
    end

  end

  test "a reply to the support address should be added as a reply post to the topic" do

    assert_no_difference('Topic.count') do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(FactoryGirl.build(:reply)).process
      end
    end

  end

  test "a user should be able to reply to a ticket by email and the ticket status should change to pending" do

    assert_difference 'Topic.where(current_status: "pending").count', 1 do
      EmailProcessor.new(FactoryGirl.build(:reply)).process
    end

  end

  test "a reply to a closed ticket should be added as a reply post to the topic and change the status to pending" do

    assert_difference 'Topic.where(current_status: "pending").count', 1 do
      assert_difference('Post.count', 1) do
        EmailProcessor.new(FactoryGirl.build(:reply_to_closed_ticket)).process
      end
    end

  end

end
