# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Charts", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    before do
      login_user(user)
    end

    it "returns http success" do
      get charts_path
      expect(response).to have_http_status(:success)
    end
  end
end
