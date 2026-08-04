Rails.application.routes.draw do
  root "static_pages#home"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/help", to: "static_pages#help"
  
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  resources :microposts, only: %i(create destroy)
  resources :users, except: :edit
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new create edit update)
end
