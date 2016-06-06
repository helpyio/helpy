require 'test_helper'
require 'generators/theme/theme_generator'

class ThemeGeneratorTest < Rails::Generators::TestCase
  tests ThemeGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
