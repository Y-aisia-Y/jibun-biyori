# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Mypage::Bases", type: :request do
  let(:user) { create(:user) }

  describe "GET /show" do
    it "正常なレスポンスを返すこと" do
      sign_in user
      get mypage_root_path
      expect(response).to have_http_status(:success)
    end
  end
end
