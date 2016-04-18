require 'integration_test_helper'


class SearchFlowsTest < ActionDispatch::IntegrationTest

  def setup
    # Build PG search
    PgSearch::Multisearch.rebuild(Doc)
    PgSearch::Multisearch.rebuild(Topic)
    set_default_settings
  end

  def teardown
  end

  test "a browsing user should be able to search from the home page" do

    visit '/en'

    within('div#body-wrapper') do
      fill_in('search-field', with: 'public')
      find('button.btn-default').click
    end

    uri = URI.parse(current_url)
    assert "#{uri.path}?#{uri.query}" == '/en/result?utf8=%E2%9C%93&q=public'

  end

end
