Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  resources :records do
    post :create_with_activity, on: :collection

    collection do
      get :health, to: 'records#new_health'
      get :diary,  to: 'records#new_diary'
    end

    resources :activities, only: [:new, :create, :edit, :update, :destroy]
    resources :record_values, only: [:create, :update]
    resource  :mood, only: [:new, :create, :edit, :update, :destroy]
  end

  # カスタム項目管理（user定義）
  resources :record_items, except: [:show] do
    member do
      patch :move_up
      patch :move_down
      patch :toggle_visibility
    end
  end

  # プロフィール設定
  resource :profile, only: %i[show edit update]

  # マイページ
  namespace :mypage do
    root to: 'base#show'
    # system項目の表示/非表示
    resource :record_item_settings, only: :show

    # system項目のトグル操作専用
    resources :record_items, only: [] do
      member do
        patch :toggle_visibility
      end
    end
  end

  # ウェルカムページ
  get 'welcome', to: 'welcome#index', as: :welcome

  unauthenticated do
    root 'welcome#index', as: :unauthenticated_root
  end

  # ログイン後にアクティブページへ
  authenticated :user do
    root 'records#index', as: :authenticated_root
  end
end
