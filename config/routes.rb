Rails.application.routes.draw do
  # Root route
  root "posts#index"

  # Public blog routes
  resources :posts, only: [:index, :show]

  # Authentication routes
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, except: [:show, :destroy, :index]

  # Admin namespace
  namespace :admin do
    root "posts#index"
    resources :posts
  end

  # System routes
  get "up" => "rails/health#show", as: :rails_health_check
end
