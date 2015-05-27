require 'test_helper'

class EmailProcessorTest < ActiveSupport::TestCase


  test "an email to the support address from an unknown user should create a new user and ticket" do

    assert_difference('Topic.count', 1) do
      assert_difference('Post.count', 1) do
        assert_difference('User.count', 1) do
          assert_difference('MandrillMailer.deliveries.size', 1) do
            EmailProcessor.new(FactoryGirl.build(:email_from_unknown)).process
          end
        end
      end
    end

  end

  test "an email to the support address from a known user should create a new ticket" do

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




end
