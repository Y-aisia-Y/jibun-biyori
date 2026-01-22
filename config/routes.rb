Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  get "dashboard", to: "records#dashboard", as: :dashboard

  resources :records do
    post :create_with_activity, on: :collection

    collection do
      get :health, to: "records#new_health"
      get :diary,  to: "records#new_diary"
    end

    member do
      get   :edit_diary   # 日記編集画面
      patch :update_diary # 日記更新
    end
    
    resources :activities, only: %i[new create edit update destroy]
    resources :record_values, only: %i[create update]
    resource  :mood
  end

  resources :record_items, except: %i[show] do
    member do
      patch :move_up
      patch :move_down
      patch :toggle_visibility
    end
  end

  resource :profile, only: %i[show edit update]

  namespace :mypage do
    root to: "base#show"

    resource :record_item_settings, only: :show

    resources :record_items, only: [] do
      member do
        patch :toggle_visibility
      end
    end
  end

  get "welcome", to: "welcome#index", as: :welcome

  unauthenticated do
    root "welcome#index", as: :unauthenticated_root
  end

  authenticated :user do
    root "records#dashboard", as: :authenticated_root
  end
end
