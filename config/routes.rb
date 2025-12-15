Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :records
  
  resources :records do
    resources :activities
  end

  resources :records do
    resources :record_values, only: [:create, :update]
  end
  
  resources :records do
    resource :mood, only: [:new, :create, :edit, :update, :destroy]
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
