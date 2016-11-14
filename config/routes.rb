Rails.application.routes.draw do
  root "products#index"
  namespace :admin do
    resources :products
  end
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

end
