require 'rails_helper'

RSpec.describe "Records", type: :request do
  # ログイン済みのユーザーを作成
  let(:user) { create(:user) }

  # 1. ログイン済みユーザーの場合のテスト
  describe "GET /records (index) - ログイン済み" do
    before do
      sign_in user 
    end

    it "HTTPステータスが200 (Success) であること" do
      # records_path は config/routes.rb の 'as: :records' に対応
      get records_path 
      # indexアクションとビューが正常に表示されるため、200 OKを期待
      expect(response).to have_http_status(:ok) 
    end
  end

  # 2. 未ログインユーザーの場合のテスト
  describe "GET /records (index) - 未ログイン" do
    it "ログインページへリダイレクトされること (302 Found)" do
      get records_path
      expect(response).to redirect_to(new_user_session_path)
      expect(response).to have_http_status(302)
    end
  end
end