Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "pages#top"
  end

  get 'home', to: 'home#index'

  get 'records', to: 'records#index', as: :records

  get "up" => "rails/health#show", as: :rails_health_check
end
