Rails.application.routes.draw do
  root "products#index"
  namespace :admin do
    resources :products do
      collection { post :import }
    end
    resources :categories do
      collection do
        get :manage
        post :rebuild
        post :expand_node
      end
    end
  end
  resources :suggestions
  devise_for :users,
    controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

end
