Rails.application.routes.draw do
  # resources :sessions, only: [:new, :create, :destroy]

  devise_for :users

  get 'search' => 'games#search'
  get 'advanced-search' => 'games#advanced_search'

  get 'games/advanced-search' => 'games#advanced_search_form'
  get 'games/most-popular' => 'games#most_popular', as: :most_popular_games
  get 'games/most-owned'   => 'games#most_owned',   as: :most_owned_games
  get 'games/most-wanted'  => 'games#most_wanted',  as: :most_wanted_games

  resources :games
  resources :users, only: [:index, :show]

  post 'games/:id/comments' => 'comments#create'
  post 'games/:id/upvote'    => 'games#upvote', as: :upvote_game
  post 'games/:id/downvote'  => 'games#downvote', as: :downvote_game
  post 'comments/:id/upvote' => 'comments#upvote', as: :upvote_comment
  post 'comments/:id/downvote' => 'comments#downvote', as: :downvote_comment
  post 'users/:id/owned_games/:game' => 'users#owned_games'
  post 'users/:id/wanted_games/:wanted_game' => 'users#wanted_games'
  post 'users/:id/:buddy' => 'users#buddies'
  post 'users/:id/buddy/:buddy_id' => 'users#change_status'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
