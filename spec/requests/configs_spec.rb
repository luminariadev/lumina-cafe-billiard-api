require 'rails_helper'

RSpec.describe 'Configs', type: :request do
  describe 'GET /api/v1/configs' do
    it 'returns app configuration' do
      get '/api/v1/configs'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['app_name']).to eq('Lumina Cafe Billiard')
      expect(json['version']).to eq('1.0.0')
      expect(json['billiard']['price_per_hour']).to eq(25_000)
    end

    it 'is accessible without auth' do
      get '/api/v1/configs'
      expect(response).to have_http_status(:ok)
    end
  end
end