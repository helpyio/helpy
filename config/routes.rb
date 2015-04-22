Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root to: "home#index"

  devise_for :users#, controllers: {
  #      sessions: 'sessions'
  #    }

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

  resources :users

  get 'topics/:id/make_private' => 'topics#make_private', as: :make_private
  get 'result' => 'result#index', as: :result
  get 'tickets' => 'topics#tickets', as: :tickets

  # Admin Routes
  get 'admin' => 'admin#dashboard', as: :admin
  get 'admin/dashboard' => 'admin#dashboard', as: :admin_dashboard
  get 'admin/knowledgebase' => 'admin#knowledgebase'
  get 'admin/knowledgebase/:category_id/articles' => 'admin#articles', as: :admin_articles
  get 'admin/tickets' => 'admin#tickets', as: :admin_tickets
  get 'admin/tickets/ticket/:id' => 'admin#ticket', as: :admin_ticket
  get 'admin/tickets/update/:id' => 'admin#update_ticket', as: :update_ticket
  get 'admin/communities'
  get 'admin/users'
  get 'admin/user/:id/edit' => 'admin#user', as: :admin_user
  get 'admin/users/search' => 'admin#user_search', as: :admin_search


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
