Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/login', to: 'sessions#create'
  resources :users, only: [:create, :show]
  resources :courses
  resources :assignments
  resources :problems
  resources :submissions
end
