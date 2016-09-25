Rails.application.routes.draw do

  root 'welcome#index'
  get '/welcome', to: 'welcome#welcome'

  devise_for :users

  resources :communities, path: '/c', only: [:show, :new, :create] do
    resources :admin, only: [:index]

    resources :championships, only: [:show, :new, :create] do
      post 'start', to: 'championships#start'
      post 'join', to: 'championships#join'

      resources :matches, only: [:show, :edit, :update] do
        post 'finish', to: 'matches#finish'
        resources :feats, only: [:new, :create, :destroy]
      end
    end
  end

  resources :teams, only: [:index, :show, :new, :create] do
    resources :players, only: [:create, :update, :destroy]
  end

  namespace :api, defaults: {format: 'json'} do
    scope :templates do
      resources :team_templates, path: '/teams', only: [:index, :show]
      resources :player_templates, path: '/players', only: [:index, :show]
      resources :skill_templates, path: '/skills', only: [:index, :show]
    end
  end
end
