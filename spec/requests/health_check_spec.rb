require 'rails_helper'

RSpec.describe "Ping API", type: :request do
  describe "GET /index" do
    it "returns 200 success and response" do
      get "/health_check/index"
      expect(response.status).to eq(200)
      expect(response.body).to eq('{"status":"API is active"}')
    end
  end
end
