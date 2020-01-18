Rails.application.routes.draw do
  root to: 'tasks#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end

  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end