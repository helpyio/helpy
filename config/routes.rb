Rails.application.routes.draw do


  root to: "locales#redirect_on_locale"
  get 'widget/' => 'widget#index', as: :widget
  get 'widget/thanks' => 'widget#thanks', as: :widget_thanks

  devise_for :users, skip: [:password, :registration, :confirmation, :invitations], controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  as :user do
    get "/users/invitation/accept" => "devise/invitations#edit", as: :accept_user_invitation
    post "/users/invitation" => "devise/invitations#create", as: :user_invitation
    put "/users/invitation" => "devise/invitations#update", as: nil
    patch "/users/invitation" => "devise/invitations#update", as: nil
  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  localized do

    root to: "home#index"

    get 'omniauth/:provider' => 'omniauth#localized', as: :localized_omniauth

    #devise_for :users, controllers: {
    #      registrations: 'registrations',
    #      omniauth_callbacks: "callbacks"
    #    }

    match 'users/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
    devise_for :users, skip: [:omniauth_callbacks, :invitations], controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords' }

    as :user do
      get "/users/invitation/accept" => "devise/invitations#edit", as: :accept_user_invitation
      post "/users/invitation" => "devise/invitations#create", as: :user_invitation
      put "/users/invitation" => "devise/invitations#update", as: nil
      patch "/users/invitation" => "devise/invitations#update", as: nil
    end

    resources :knowledgebase, :as => 'categories', :controller => "categories", except: [:new, :edit, :create, :update] do
      resources :docs, except: [:new, :edit, :create, :update]
    end

    resources :docs, except: [:new, :edit] do
      resources :comments, only: :create
    end
    resources :community, :as => 'forums', :controller => "forums" do
      resources :topics
    end
    resources :topics do
      resources :posts
    end
    resources :posts

    post 'topic/:id/vote' => 'topics#up_vote', as: :up_vote, defaults: { format: 'js' }
    post 'post/:id/vote' => 'posts#up_vote', as: :post_vote, defaults: { format: 'js' }
    get 'thanks' => 'topics#thanks', as: :topic_thanks
    get 'result' => 'result#index', as: :result
    get 'search' => 'result#search', as: :search
    get 'tickets' => 'topics#tickets', as: :tickets
    get 'ticket/:id/' => 'topics#ticket', as: :ticket
    get 'locales/select' => 'locales#select', as: :select_locale
  end

  get '/switch_locale' => 'home#switch_locale', as: :switch_locale

  # Admin Routes

  namespace :admin do

    # Extra topic Routes
    get 'topics/update_topic' => 'topics#update_topic', as: :update_topic, defaults: {format: 'js'}
    get 'topics/update_multiple' => 'topics#update_multiple_tickets', as: :update_multiple_tickets
    get 'topics/assign_agent' => 'topics#assign_agent', as: :assign_agent
    get 'topics/toggle_privacy' => 'topics#toggle_privacy', as: :toggle_privacy
    get 'topics/:id/toggle' => 'topics#toggle_post', as: :toggle_post
    get 'topics/assign_team' => 'topics#assign_team', as: :assign_team

    # SearchController Routes
    get 'search/topic_search' => 'search#topic_search', as: :topic_search

    # Settings Routes
    get 'settings' => 'settings#index', as: :settings
    get 'settings/preview' => 'settings#preview', as: :preview
    put 'update_settings/' => 'settings#update_settings', as: :update_settings
    get 'notifications' => 'settings#notifications', as: :notifications
    put 'update_notifications' => 'settings#update_notifications', as: :update_notifications

    # Onboarding Routes
    get '/onboarding/index' => 'onboarding#index', as: :onboarding
    patch '/onboarding/update_user' => 'onboarding#update_user', as: :onboard_user
    patch '/onboarding/update_settings' => 'onboarding#update_settings', as: :onboard_settings
    get '/onboarding/complete' => 'onboarding#complete', as: :complete_onboard

    # Misc Routes
    post 'shared/update_order' => 'shared#update_order', as: :update_order
    get 'cancel_edit_post/:id/' => 'posts#cancel', as: :cancel_edit_post
    get 'users/invite' => 'users#invite', as: :invite
    put 'users/invite_users' => 'users#invite_users', as: :invite_users

    resources :categories do
      resources :docs, except: [:index, :show]
    end
    resources :docs, except: [:index, :show]

    resources :images, only: [:create, :destroy]
    resources :forums# , except: [:index, :show]
    resources :users
    resources :api_keys, except: [:show, :edit, :update]
    resources :topics, except: [:delete, :edit, :update] do
      resources :posts
    end
    resources :posts
    get '/dashboard' => 'dashboard#index', as: :dashboard
    get '/team' => 'dashboard#stats', as: :stats
    root to: 'dashboard#index'
  end

  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine => '/api/v1/api_doc'

  # Receive email from Griddler
  mount_griddler

  # Mount attachinary
  mount Attachinary::Engine => "/attachinary"

end
