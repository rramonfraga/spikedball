Rails.application.routes.draw do

  root 'welcome#index'
  get '/welcome', to: 'welcome#welcome'

  devise_for :users

  resources :communities, path: '/c', param: :code, only: [:show, :new, :create] do
    resources :admin, only: [:index]
    resources :fast_rules, only: [:index]

    resources :championships, only: [:show, :new, :create] do
      member do
        post 'start'
        post 'join'
      end

      resources :matches, only: [:show, :edit, :update] do
        patch 'finish', on: :member
        resources :feats, only: [:new, :create, :destroy]
      end
    end
  end

  shallow do
    resources :teams, only: [:index, :show, :new, :create] do
      member do
        get 'add_re_roll'
        get 'add_apothecary'
        get 'add_freelance'
      end
      resources :players, only: [:new, :create, :show, :edit, :update, :destroy] do
        member do
          post 'fire'
        end
        resources :level_rises, only: [:create, :edit, :update]
      end
    end
  end

  namespace :api, defaults: {format: 'json'} do
    scope :templates do
      resources :team_templates, path: '/teams', only: [:index, :show]
      resources :player_templates, path: '/players', only: [:index, :show]
      resources :start_players, path: '/start_players', only: [:index, :show]
      resources :skill_templates, path: '/skills', only: [:index, :show]
    end
  end
end
