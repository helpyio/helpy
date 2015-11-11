require 'test_helper'

class LocalesControllerTest < ActionController::TestCase

  def one_locale
    config.i18n.default_locale = :en
    config.i18n.available_locales = ['en']
  end

  def multi_locale
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:en, :fr, :et]
  end


  test "a browsing user requesting the root domain should get redirected to the default language" do
    one_locale

    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :en)
    end
  end

  test "a browsing user requesting the root domain should get redirected to the default language when multiple languages are set" do
    multi_locale

    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :fr)
    end
  end

  test "a browsing user requesting the root domain should get redirected to the browser language" do
    multi_locale

    @request.headers["Accept-Lanuage"] = "et"
    get :redirect_on_locale do
      assert_redirected_to(controller: 'home', action: 'index', locale: :et)
    end
  end


end
