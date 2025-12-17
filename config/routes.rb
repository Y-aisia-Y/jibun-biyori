Rails.application.routes.draw do
  get 'record_items/index'
  get 'record_items/new'
  get 'record_items/create'
  get 'record_items/edit'
  get 'record_items/update'
  get 'record_items/destroy'
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :records
  resource :mypage, only: [:show]
  resources :record_items, except: [:show]

  resources :records do
    resources :activities
  end

  resources :records do
    resources :record_values, only: [:create, :update]
  end
  
  resources :records do
    resource :mood, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :record_items do
    member do
      patch :toggle_visibility
    end
  end

  resources :record_items do
    member do
      patch :move_up
      patch :move_down
      patch :toggle_visibility
    end
  end

  get 'welcome', to: 'welcome#index', as: :welcome

  # ログイン済み
  authenticated :user do
    root 'pages#top', as: :authenticated_root
  end

  # 未ログイン
  unauthenticated do
    root 'welcome#index', as: :unauthenticated_root
  end
end
