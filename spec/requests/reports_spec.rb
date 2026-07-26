require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let(:admin_user) { create(:user, username: 'admin', password: 'admin123', role: :admin) }

  describe 'GET /api/v1/reports' do
    it 'returns report data for admin' do
      post '/api/v1/auth/login', params: { username: 'admin', password: 'admin123' }, as: :json
      token = JSON.parse(response.body)['token']

      get '/api/v1/reports', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.keys).to include('today_revenue', 'monthly_revenue', 'best_sellers')
    end

    it 'rejects non-admin users' do
      create(:user, username: 'kasir', password: 'kasir123', role: :kasir_billiard)
      post '/api/v1/auth/login', params: { username: 'kasir', password: 'kasir123' }, as: :json
      token = JSON.parse(response.body)['token']

      get '/api/v1/reports', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:forbidden)
    end

    it 'requires authentication' do
      get '/api/v1/reports'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end