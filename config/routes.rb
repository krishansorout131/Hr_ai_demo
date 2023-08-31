Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/login', to: 'users/sessions#create'
  post '/signup', to: 'users/registrations#create'
  post '/reset_password', to: 'users/sessions#reset_password'
  post '/forget_password', to: 'users/sessions#forget_password'
  
  post '/edit_password', to: 'users/sessions#edit_password'
  get '/get_user_details', to: 'users/sessions#get_user'

  root to: "home#index"
end
