Rails.application.routes.draw do
  scope '/api' do
    post '/login',    to: 'sessions#create'
    post '/exec',     to: 'submissions#exec'
    post '/admin',    to: 'users#create_admin'

    resources :users, only: [:create, :show]
    resources :courses
    resources :assignments
    resources :problems
    resources :submissions
  end
end
