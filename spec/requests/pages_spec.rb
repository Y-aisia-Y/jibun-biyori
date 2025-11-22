require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /users/sign_in" do
    it "はログインページを正常に表示すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Email")
    end
  end

  describe "GET /users/sign_up" do
    it "は新規登録ページを正常に表示すること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("Password confirmation")
    end
  end
end
