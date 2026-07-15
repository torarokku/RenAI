Rails.application.routes.draw do
  get 'conversations/index'
  get 'sessions/new'
  get 'users/new'
  get 'home/index'

  root "home#index"

  resources :users, only: [:new, :create]

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :conversations, only: [:index, :create] do
    collection do
      delete :destroy_all
    end
  end
end