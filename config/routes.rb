Rails.application.routes.draw do
  scope '/api' do
    post '/login',    to: 'sessions#create'
    post '/exec',     to: 'submissions#exec'

    # users related
    resources :users, only: [:show]
    post '/admin',    to: 'users#create_admin'
    get '/users/oauth/github', to: 'users#oauth_github'
    get '/users/oauth/google', to: 'users#oauth_google'
    get '/user', to: 'users#current'

    get '/courses/visible', to: 'courses#get_visible'
    resources :courses, only: [:create, :show, :update, :destroy] do
      resources :invites, only: [:create]
      resources :assignments, only: [:create, :index]
    end
    resources :assignments, only: [:show, :update, :destroy] do
        resources :problems, only: [:create, :index]
    end
    resources :problems, only: [:show, :update, :destroy] do
      resources :submissions, only: [:create, :index]
      resources :tests, only: [:create, :index]
    end

    resources :submissions, only: [:show]
    get '/submissions/:id/file', to: 'submissions#show_file'
    resources :tests, only: [:show, :update, :destroy]
    get '/tests/:id/file', to: 'tests#show_file'

    get '/files/:id', to: 'db_files#show'

    get '/courses/:course_id/unused', to: 'invites#unused'
    get '/invites/:invite_id/redeem', to: 'invites#redeem'
    post '/invites/:invite_id/resend', to: 'invites#resend'
  end
end
