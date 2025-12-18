Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :records do
    resources :activities
    resources :record_values, only: [:create, :update]
    resource :mood, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :record_items, except: [:show] do
    member do
      patch :move_up
      patch :move_down
      patch :toggle_visibility
    end
  end

  resource :mypage, only: [:show]
  get 'welcome', to: 'welcome#index', as: :welcome

  authenticated :user do
    root 'pages#top', as: :authenticated_root
  end

  unauthenticated do
    root 'welcome#index', as: :unauthenticated_root
  end
end
