Rails.application.routes.draw do
  root "products#index"
  resources :products, only: [:show, :index]
  resources :category, only: :show
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  resources :carts, except: [:show, :edit, :update]
  resources :orders, only: :new
end
