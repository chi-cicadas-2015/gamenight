Rails.application.routes.draw do
  # resources :sessions, only: [:new, :create, :destroy]

  devise_for :users

  resources :games
  resources :users, only: [:show]

  post 'games/:id/comments' => 'comments#create'
  post 'games/:id/upvote'    => 'games#upvote', as: :upvote_game
  post 'games/:id/downvote'  => 'games#downvote', as: :downvote_game
  post 'comments/:id/upvote' => 'comments#upvote', as: :upvote_comment
  post 'comments/:id/downvote' => 'comments#downvote', as: :downvote_comment
  post 'users/:id/:buddy' => 'users#buddies'
  post 'users/:id/:game' => 'users#owned_games'
  post 'users/:id/:wanted_game' => 'users#wanted_games'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'games#index'

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
