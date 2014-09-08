Rails.application.routes.draw do
  root to: "sites#index"
  get "/login", to: "sessions#new", as: "sessions"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  get "/sign_up", to: "users#new"
  resources :users do
    resources :posts, only: [:index, :show, :new]
  end
  resources :posts
end
