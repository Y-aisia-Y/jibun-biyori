# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Welcomes", type: :request do
  describe "GET /" do
    it "ログインしていない場合、正常にレスポンスを返すこと" do
      get unauthenticated_root_path
      expect(response).to have_http_status(:success)
    end
  end
end
