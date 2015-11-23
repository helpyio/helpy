require 'test_helper'

class LocalesControllerTest < ActionController::TestCase

  setup do
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  test "a browsing user requesting the root domain should get redirected to the default language" do
    I18n.default_locale = :en
    I18n.available_locales = ['en']

    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :en)
    end
  end

  test "a browsing user requesting the root domain should get redirected to the default language when multiple languages are set" do

    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :fr)
    end
  end

  test "a browsing user requesting the root domain should get redirected to the browser language" do

    @request.headers["Accept-Lanuage"] = "et"
    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :et)
    end
  end


end
