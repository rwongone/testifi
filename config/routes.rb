Rails.application.routes.draw do
  scope '/api' do
    post '/login',    to: 'sessions#create'
    post '/exec',     to: 'submissions#exec'

    # users related
    resources :users, only: [:show]
    post '/admin',    to: 'users#create_admin'
    get '/users/oauth/github', to: 'users#oauth_github'
    get '/users/oauth/google', to: 'users#oauth_google'
    get '/logout', to: 'users#logout'
    get '/user', to: 'users#current'

    get '/courses/visible', to: 'courses#get_visible'
    resources :courses, only: [:create, :update, :destroy] do
      resources :invites, only: [:create]
      resources :assignments, only: [:create, :index]
      get 'students', to: 'courses#students'
      get 'invites/unused', to: 'invites#unused'
    end

    resources :assignments, only: [:show, :update, :destroy] do
        resources :problems, only: [:create, :index]
    end

    resources :problems, only: [:show, :update, :destroy] do
      resources :submissions, only: [:create, :index]
      resources :tests, only: [:create, :index]
    end

    resources :submissions, only: [:show] do
      get 'file', to: 'submissions#show_file'
      get 'results', to: 'executions#results'
    end

    resources :tests, only: [:show, :update, :destroy] do
      get 'file', to: 'tests#show_file'
    end

    get '/files/:id', to: 'db_files#show'

    get '/invites/:invite_id/redeem', to: 'invites#redeem'
    post '/invites/:invite_id/resend', to: 'invites#resend'
  end
end
