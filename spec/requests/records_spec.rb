# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Records", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/records/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/records/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/records/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/records/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
