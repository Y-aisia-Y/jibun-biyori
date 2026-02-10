# frozen_string_literal: true

Rails.application.routes.draw do
  get 'charts/index'
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  get "dashboard", to: "records#dashboard", as: :dashboard

  resources :records do
    collection do
      get :dashboard
      get :new_health
      get :new_diary
      post :create_with_activity
      post :create_diary
    end

    member do
      get :edit_diary
      patch :update_diary
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
        post :toggle_visibility
      end
    end
  end

  get "welcome", to: "welcome#index", as: :welcome
  get 'charts', to: 'charts#index'

  unauthenticated do
    root "welcome#index", as: :unauthenticated_root
  end

  authenticated :user do
    root "records#dashboard", as: :authenticated_root
  end
end
