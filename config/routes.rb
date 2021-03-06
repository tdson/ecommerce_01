Rails.application.routes.draw do
  namespace :admin do
    root "orders#index", status: Settings.order_status[:pending]
    resources :statistics, only: :index
    resources :orders, except: [:new, :create]
    resources :order_products, only: [:update, :destroy]
    resources :suggestions, only: [:index, :update, :destroy]
    resources :users, only: [:index, :destroy]
    resources :products do
      collection {post :import}
    end
    resources :categories do
      collection do
        get :manage
        post :rebuild
        post :expand_node
      end
    end
  end

  root "home#index"
  resources :products, only: [:show, :index] do
    resources :ratings, only: :create
  end
  resources :category, only: :show
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  resources :carts, except: [:show, :edit, :update]
  resources :orders, except: [:index, :edit, :destroy]
  resources :users, only: [:show, :edit, :update] do
    resources :orders, only: [:index, :show]
  end
  resources :recently_viewed_products, only: :index
  resources :suggestions, only: [:new, :create]
end
