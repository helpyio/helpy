Rails.application.routes.draw do

  root to: "locales#redirect_on_locale"
  get 'widget/' => 'widget#index', as: :widget
  get 'widget/thanks' => 'widget#thanks', as: :widget_thanks

  devise_for :users, skip: [:password, :registration, :confirmation], controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  localized do

    root to: "home#index"

    get 'omniauth/:provider' => 'omniauth#localized', as: :localized_omniauth

    #devise_for :users, controllers: {
    #      registrations: 'registrations',
    #      omniauth_callbacks: "callbacks"
    #    }

    devise_for :users, skip: :omniauth_callbacks, controllers: { registrations: 'registrations' }

    resources :knowledgebase, :as => 'categories', :controller => "categories", except: [:new, :edit, :create, :update] do
      resources :docs, except: [:new, :edit, :create, :update]
    end

    resources :docs, except: [:new, :edit]
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
    get 'tickets' => 'topics#tickets', as: :tickets
    get 'ticket/:id/' => 'topics#ticket', as: :ticket
    get 'locales/select' => 'locales#select', as: :select_locale
  end

  get '/switch_locale' => 'home#switch_locale', as: :switch_locale
  get '/set_client_id' => 'home#set_client_id', as: :set_client_id

  # Admin Routes

  namespace :admin do

    # Extra topic Routes
    get 'topics/update_topic' => 'topics#update_topic', as: :update_topic, defaults: {format: 'js'}
    get 'topics/update_multiple' => 'topics#update_multiple_tickets', as: :update_multiple_tickets
    get 'topics/assign_agent' => 'topics#assign_agent', as: :assign_agent
    get 'topics/toggle_privacy' => 'topics#toggle_privacy', as: :toggle_privacy
    get 'topics/:id/toggle' => 'topics#toggle_post', as: :toggle_post

    # SearchController Routes
    get 'search/topic_search' => 'search#topic_search', as: :topic_search
    get 'settings' => 'settings#index', as: :settings
    put 'update_settings/' => 'settings#update_settings', as: :update_settings

    post 'shared/update_order' => 'shared#update_order', as: :update_order

    get 'cancel_edit_post/:id/' => 'posts#cancel', as: :cancel_edit_post

    resources :categories do
      resources :docs, except: [:index, :show]
    end
    resources :docs, except: [:index, :show]
    resources :forums# , except: [:index, :show]
    resources :users
    resources :topics, except: [:delete, :edit, :update] do
      resources :posts
    end
    resources :posts
    # get '/dashboard' => 'admin#dashboard', as: :admin_dashboard
    root to: 'dashboard#index'
  end

  # Receive email from Griddler
  mount_griddler

  # Mount attachinary
  mount Attachinary::Engine => "/attachinary"

end
