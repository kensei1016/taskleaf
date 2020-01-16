Rails.application.routes.draw do
  root to: 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :admin ωdo
    resources :users
  end
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end