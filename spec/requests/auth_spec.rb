require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  let!(:user) { create(:user, username: 'admin', password: 'admin123', role: :admin) }

  describe 'POST /api/v1/auth/login' do
    it 'returns token for valid credentials' do
      post '/api/v1/auth/login', params: { username: 'admin', password: 'admin123' }, as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
      expect(json['user']['username']).to eq('admin')
    end

    it 'rejects invalid password' do
      post '/api/v1/auth/login', params: { username: 'admin', password: 'wrong' }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v1/auth/me' do
    it 'returns user profile with valid token' do
      post '/api/v1/auth/login', params: { username: 'admin', password: 'admin123' }, as: :json
      token = JSON.parse(response.body)['token']

      get '/api/v1/auth/me', headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['username']).to eq('admin')
    end

    it 'rejects request without token' do
      get '/api/v1/auth/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
