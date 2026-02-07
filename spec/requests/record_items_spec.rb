# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "RecordItems", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "GET /record_items" do
    it "正常にレスポンスを返すこと" do
      get record_items_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /record_items/new" do
    it "正常にレスポンスを返すこと" do
      get new_record_item_path
      expect(response).to have_http_status(:success)
    end
  end
end
