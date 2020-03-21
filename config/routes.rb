Rails.application.routes.draw do
  root to: 'static_page#index'
  get '/about', to: 'static_page#index'
  get '/contact', to: 'static_page#index'
  get '/users/new', to: 'static_page#index'
  get '/login', to: 'static_page#index'
  scope :api do
    post '/login', to: 'sessions#create'
    post '/users/new', to: 'users#create'
    post '/users/delete', to: 'users#delete'
    get '/tasks', to: 'tasks#index'
    post '/tasks/new', to: 'tasks#create'
  end
  get '*not_found' => 'static_page#rescue404'
  post '*not_found' => 'application#rescue404'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
