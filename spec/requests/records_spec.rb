# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Records", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "正常なレスポンスを返すこと" do
      get records_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "正常なレスポンスを返すこと" do
      get new_record_path, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let!(:record) { create(:record, user: user) }

    it "正常なレスポンスを返すこと" do
      get record_path(record), as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end
end
