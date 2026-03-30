Rails.application.routes.draw do
  get 'carts/show'
  get 'contact/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  get "about", to: "about#index"
  get "/contact", to: "contact#show"

  resource :cart, only: [:show] do
    post "add/:product_id", to: "carts#add", as: :add
    patch "update/:product_id", to: "carts#update", as: :update
    delete "remove/:product_id", to: "carts#remove", as: :remove
  end
end
