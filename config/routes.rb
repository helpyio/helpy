Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root to: "home#index"

  devise_for :users, controllers: {
        registrations: 'registrations'
      }

  resources :knowledgebase, :as => 'categories', :controller => "categories" do
    #collection do
    #  get 'admin'
    #end
    resources :docs
  end
  resources :docs
  resources :community, :as => 'forums', :controller => "forums" do
    resources :topics
  end
  resources :topics do
    resources :posts
  end
  resources :posts

  #resources :users

  get 'result' => 'result#index', as: :result
  get 'tickets' => 'topics#tickets', as: :tickets
  get 'ticket/:id/' => 'topics#ticket', as: :ticket

  # Admin Routes
  get 'admin' => 'admin#tickets', as: :admin
  get 'admin/dashboard' => 'admin#dashboard', as: :admin_dashboard
  get 'admin/content' => 'admin#knowledgebase', as: :admin_knowledgebase
  get 'admin/content/:category_id/articles' => 'admin#articles', as: :admin_articles
  get 'admin/tickets' => 'admin#tickets', as: :admin_tickets
  get 'admin/ticket/:id' => 'admin#ticket', as: :admin_ticket
  get 'admin/tickets/new' => 'admin#new_ticket', as: :admin_new_ticket
  post 'admin/tickets/create' => 'admin#create_ticket', as: :admin_create_ticket
  get 'admin/tickets/update/:id' => 'admin#update_ticket', as: :update_ticket
  get 'admin/tickets/assign_agent/:id' => 'admin#assign_agent', as: :assign_agent
  get 'admin/tickets/:id/toggle_privacy' => 'admin#toggle_privacy', as: :toggle_privacy
  get 'admin/tickets/:id/toggle' => 'admin#toggle_post', as: :toggle_post
  get 'admin/communities' => 'admin#communities', as: :admin_communities
  get 'admin/users'
  get 'admin/user/:id/edit' => 'admin#user', as: :admin_user
  get 'admin/topic_search' => 'admin#topic_search', as: :admin_search
  get 'admin/user_search' => 'admin#user_search', as: :user_search


  # Receive email from Griddler
  mount_griddler

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
