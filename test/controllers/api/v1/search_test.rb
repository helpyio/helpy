require 'test_helper'

class API::V1::SearchTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end
  
  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Search Key", user: @user)
    @default_params = { token: @api_key.access_token }


    @docs = []
    @docs << docs(:one)
    @docs << docs(:two)
    @docs << docs(:three)
    @docs << docs(:six)

    # Need to rebuild the results to ensure they are ready
    PgSearch::Multisearch.rebuild(Doc)
  end

  test "an unauthenticated user should receive an unauthorized message" do
    get "/api/v1/search.json"

    # Check not authorized
    assert_equal 401, last_response.status
  end 

  test "it should require a query parameter" do
    get "/api/v1/search.json", @default_params

    # Check 400 response
    assert_equal 400, last_response.status
  end  

  test "an API user should be able to return some results" do
    get "/api/v1/search.json", @default_params.merge(q: 'Article')

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert_equal 4, objects['results'].count
  end

  test "an API user should be able to return some results filtered by type" do
    get "/api/v1/search.json", @default_params.merge(q: 'Article', type: 'docs')

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    #raise objects.inspect
    assert_equal 4, objects['results'].count
  end


  test "results filtered by type should return the proper Entity" do
    get "/api/v1/search.json", @default_params.merge(q: @docs.first.title, type: 'docs')

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    results = objects['results']
    assert_equal 1, results.count

    # Check returned Entity
    assert_equal @docs.first.title, results.first['title']
  end  

end
