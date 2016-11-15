Rails.application.routes.draw do
  root "products#index"
  resources :products, only: [:show, :index]
  resources :category, only: :show
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
end
