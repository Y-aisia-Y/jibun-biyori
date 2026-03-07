# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /terms" do
    it "returns http success" do
      get terms_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      get privacy_path
      expect(response).to have_http_status(:success)
    end
  end
end
