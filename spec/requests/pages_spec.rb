# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_in" do
    it "はログインページを正常に表示すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("じぶん日和")
    end
  end

  describe "POST /guest_sign_in" do
    it "はゲストユーザーを作成し、トップページにリダイレクトすること" do
      expect do
        post guest_sign_in_path
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("users.sessions.guest_signed_in"))
    end
  end
end
