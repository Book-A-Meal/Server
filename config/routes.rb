Rails.application.routes.draw do
  resources :meals
  resources :admins
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/admin/login", to: "admins#login"
  delete '/admins/logout', to: 'admins#logout'

  delete '/users/logout', to: 'users#logout'
  post "/user/login", to: "users#login"
end
