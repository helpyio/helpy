Rails.application.routes.draw do


  root to: "locales#redirect_on_locale"

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
    devise_for :users, skip: [:omniauth_callbacks], controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords', invitations: 'invitations' }

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
    resources :posts do
      resources :flags, only: [:create]
    end

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

  # Widget Routes
  get 'widget' => 'widget/topics#new', as: :widget
  namespace :widget do
    get 'index' => 'topics#new', as: :widget
    post 'topics' => 'topics#create', as: :create
    get 'topics/thanks' => 'topics#thanks', as: :thanks
  end

  # Webhook Routes
  namespace :webhook do
    post 'form/:token' => 'inbound#form', as: :form
  end

  # Admin Routes

  namespace :admin do

    # Extra topic Routes
    get 'topics/update_topic' => 'topics#update_topic', as: :update_topic, defaults: {format: 'js'}
    post 'topics/merge_tickets' => 'topics#merge_tickets', as: :merge_tickets
    patch 'topics/update_tags' => 'topics#update_tags', as: :update_topic_tags
    get 'topics/update_multiple' => 'topics#update_multiple_tickets', as: :update_multiple_tickets
    get 'topics/assign_agent' => 'topics#assign_agent', as: :assign_agent
    get 'topics/unassign_agent' => 'topics#unassign_agent', as: :unassign_agent
    get 'topics/toggle_privacy' => 'topics#toggle_privacy', as: :toggle_privacy
    get 'topics/:id/toggle' => 'topics#toggle_post', as: :toggle_post
    get 'topics/assign_team' => 'topics#assign_team', as: :assign_team
    get 'topics/unassign_team' => 'topics#unassign_team', as: :unassign_team
    post 'topics/:topic_id/split/:post_id' => 'topics#split_topic', as: :split_topic
    get 'shortcuts' => 'topics#shortcuts', as: :shortcuts
    get 'empty_trash' => 'topics#empty_trash', as: :empty_trash

    # SearchController Routes
    get 'search/topic_search' => 'search#topic_search', as: :topic_search

    # Settings Routes
    get 'settings' => 'settings#index', as: :settings
    get 'settings/preview' => 'settings#preview', as: :preview
    put 'update_settings/' => 'settings#update_settings', as: :update_settings
    get 'settings/general' => 'settings#general', as: :general_settings
    get 'settings/design' => 'settings#design', as: :design_settings
    get 'settings/theme' => 'settings#theme', as: :theme_settings
    get 'settings/widget' => 'settings#widget', as: :widget_settings
    get 'settings/i18n' => 'settings#i18n', as: :i18n_settings
    get 'settings/email' => 'settings#email', as: :email_settings
    get 'settings/integration' => 'settings#integration', as: :integration_settings
    put 'settings/general' => 'settings#update_general', as: :update_general_settings
    put 'settings/design' => 'settings#update_design', as: :update_design_settings
    put 'settings/theme' => 'settings#update_theme', as: :update_theme_settings
    put 'settings/widget' => 'settings#update_widget', as: :update_widget_settings
    put 'settings/i18n' => 'settings#update_i18n', as: :update_i18n_settings
    put 'settings/email' => 'settings#update_email', as: :update_email_settings
    put 'settings/integration' => 'settings#update_integration', as: :update_integration_settings
    get 'settings/profile' => 'settings#profile', as: :profile_settings
    get 'settings/trash' => 'settings#trash', as: :trash_settings

    # Misc Routes
    post 'shared/update_order' => 'shared#update_order', as: :update_order
    get 'cancel_edit_post/:id/' => 'posts#cancel', as: :cancel_edit_post
    get 'users/invite' => 'users#invite', as: :invite
    put 'users/invite_users' => 'users#invite_users', as: :invite_users

    # Export Routes
    get 'backups' => 'backups#index', as: :backups
    get 'backups/export' => "backups/export", as: :export_backup
    get  'backups/download' => "backups/download", as: :download
    delete 'backups/:id(.:format)', :to => 'backups#destroy', as: :delete_backup

    # Import Routes
    resources :imports, only: [:index, :show]
    post 'imports/restore' => "importz/restore", as: :import_restore

    post 'posts/users' => 'posts#search', as: :user_search
    get  'posts/new_user' => 'posts#new_user', as: :new_user
    post  'posts/new_user' => 'posts#change_owner_new_user'

    get 'internal_docs/search' => 'internal_categories#search', as: :internal_docs_search

    patch 'categories/reorganize' => 'categories#reorganize', as: :reorganize
    resources :categories do
      resources :docs, except: [:index, :show]
    end


    resources :internal_categories, only: [:index, :show] do
      resources :internal_docs, only: :show
    end

    resources :docs, except: [:index, :show]
    get 'agent_assistant' => 'agent_assistant#index', as: :agent_assist

    resources :images, only: [:create, :destroy]
    resources :forums# , except: [:index, :show]
    resources :users
    post 'users/:id/scrub' => 'users#scrub', as: :scrub_user
    scope 'settings' do
      resources :api_keys, except: [:show, :edit, :update]
      resources :groups
      resources :tags
    end
    resources :topics, except: [:delete, :edit] do
      resources :posts
    end
    resources :posts
    
    get '/posts/:id/raw' => 'posts#raw', as: :post_raw
    get '/dashboard' => 'dashboard#index', as: :dashboard
    get '/reports/team' => 'reports#team', as: :team_reports
    get '/reports/groups' => 'reports#groups', as: :group_reports
    get '/reports' => 'reports#index', as: :reports

    get '/dashboard/blank' => 'dashboard#blank', as: :blank_dashboard

    root to: 'dashboard#index'
  end

  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine => '/api/v1/api_doc'

  # Receive email from Griddler
  mount_griddler

  # Mount attachinary
  mount Attachinary::Engine => "/attachinary"

end
