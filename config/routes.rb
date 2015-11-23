Rails.application.routes.draw do


  root to: "locales#redirect_on_locale"


  localized do

    root to: "home#index"

    devise_for :users, controllers: {
          registrations: 'registrations'
        }


    resources :knowledgebase, :as => 'categories', :controller => "categories", except: [:new, :edit] do
      #collection do
      #  get 'admin'
      #end
      resources :docs, except: [:new, :edit]
    end

    resources :docs, except: [:new, :edit]
    resources :community, :as => 'forums', :controller => "forums" do
      resources :topics
    end
    resources :topics do
      resources :posts
    end
    resources :posts

    resources :users

    post 'topic/:id/vote' => 'topics#up_vote', as: :up_vote
    post 'post/:id/vote' => 'posts#up_vote', as: :post_vote
    get 'result' => 'result#index', as: :result
    get 'tickets' => 'topics#tickets', as: :tickets
    get 'ticket/:id/' => 'topics#ticket', as: :ticket
    get 'cancel_edit_post/:id/' => 'posts#cancel', as: :cancel_edit_post
    get 'locales/select' => 'locales#select', as: :select_locale
  end

  get '/switch_locale' => 'home#switch_locale', as: :switch_locale

  # Admin Routes

  scope 'admin' do

    get '/' => 'admin#tickets', as: :admin

    resources :docs, only: [:new, :edit]
    resources :knowledgebase, :as => 'categories', :controller => "categories", only: [:new, :edit] do
      resources :docs, only: [:new, :edit]
    end

    get '/dashboard' => 'admin#dashboard', as: :admin_dashboard
    get '/content' => 'admin#knowledgebase', as: :admin_knowledgebase
    get '/content/:category_id/articles' => 'admin#articles', as: :admin_articles
    get '/tickets' => 'admin#tickets', as: :admin_tickets
    get '/ticket/:id' => 'admin#ticket', as: :admin_ticket
    get '/tickets/new' => 'admin#new_ticket', as: :admin_new_ticket
    post '/tickets/create' => 'admin#create_ticket', as: :admin_create_ticket
    get '/tickets/update' => 'admin#update_ticket', as: :update_ticket, defaults: {format: 'js'}
    get '/tickets/update_multiple' => 'admin#update_multiple_tickets', as: :update_multiple_tickets
    get '/tickets/assign_agent' => 'admin#assign_agent', as: :assign_agent
    get '/tickets/toggle_privacy' => 'admin#toggle_privacy', as: :toggle_privacy
    get '/tickets/:id/toggle' => 'admin#toggle_post', as: :toggle_post
    get '/communities' => 'admin#communities', as: :admin_communities
    #get '/users'
    get '/user/:id/edit' => 'admin#edit_user', as: :admin_user
    get '/user/:id' => 'admin#user_profile', as: :user_profile
    get '/topic_search' => 'admin#topic_search', as: :admin_search
    get '/user_search' => 'admin#user_search', as: :user_search

  end




  # Receive email from Griddler
  mount_griddler

  # Mount attachinary
  mount Attachinary::Engine => "/attachinary"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
