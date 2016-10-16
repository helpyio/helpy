require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  should belong_to(:post)
end
