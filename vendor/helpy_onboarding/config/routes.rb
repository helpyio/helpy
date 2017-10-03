Rails.application.routes.draw do

  namespace :admin do
    # Onboarding Routes
    get '/onboarding/index' => 'onboarding#index', as: :onboarding
    patch '/onboarding/update_user' => 'onboarding#update_user', as: :onboard_user
    patch '/onboarding/update_settings' => 'onboarding#update_settings', as: :onboard_settings
    get '/onboarding/complete' => 'onboarding#complete', as: :complete_onboard
  end

end
