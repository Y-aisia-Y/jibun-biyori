Rails.application.routes.draw do
  # 1. Deviseの認証ルーティング
  devise_for :users
  # 2. 記録ページへのアクセス
  get 'records', to: 'records#index', as: :records
  # 3. TOPページ
  root "pages#top"
  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check
end
