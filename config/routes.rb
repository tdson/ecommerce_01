Rails.application.routes.draw do
  namespace :admin do
    resources :statistics, only: :index
  end

  root "products#index"
  resources :products, only: :show
  resources :category, only: :show
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  post "cart/create", to: "carts#create", as: :add_to_cart
  get "cart/clear", to: "carts#destroy", as: :clear_cart
  delete "cart/:product_id", to: "carts#remove", as: :remove_cart_item
  get "cart", to: "carts#index"
  resources :orders, only: [:new, :create, :show]
end
