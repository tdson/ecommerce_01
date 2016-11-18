Rails.application.routes.draw do
  root "products#index"
  resources :products, only: [:show, :index] do
    resources :ratings, only: :create
  end
  resources :category, only: :show
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  resources :carts, except: [:show, :edit, :update]
  resources :orders, only: [:new, :create, :show]
  resources :users, only: [:show, :edit, :update] do
    resources :orders, only: [:index, :show]
  end
  resources :recently_viewed_products, only: :index
  resources :suggestions, only: [:new, :create]
end
