# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  # Deviseのヘルパー（current_userなど）をコントローラースペックで使えるようにする
  include Devise::Test::ControllerHelpers

  # ログイン必須ページ（records#index）へのアクセス権限をテスト
  describe "GET #index" do
    context "未ログインユーザーの場合" do
      it "ログインページへリダイレクトされること" do
        get :index
        # 未ログインの場合、Deviseはサインインパスへリダイレクトする
        expect(response).to redirect_to(new_user_session_path)
      end

      it "HTTPステータスが302（リダイレクト）であること" do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    context "ログイン済みユーザーの場合" do
      # テスト用のユーザーを作成（FactoryBotを使用）
      let(:user) { create(:user) }

      # テスト実行前にユーザーをログインさせる
      before do
        # Deviseのヘルパーを使ってサインインさせる
        sign_in user
      end

      it "正常なレスポンスを返すこと（Recordsページが表示されること）" do
        get :index
        expect(response).to have_http_status(200)
        # indexアクションが正しく実行され、テンプレートがレンダリングされることを確認
        expect(response).to render_template(:index)
      end
    end
  end
end
