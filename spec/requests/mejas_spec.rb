require 'rails_helper'

RSpec.describe 'Mejas', type: :request do
  let(:user) { create(:user, username: 'admin', password: 'admin123', role: :admin) }

  describe 'GET /api/v1/mejas' do
    it 'returns all mejas' do
      create_list(:meja, 3)
      get '/api/v1/mejas'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(3)
    end

    it 'returns paginated results' do
      create_list(:meja, 5)
      get '/api/v1/mejas', params: { page: 1, per_page: 2 }
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(2)
      expect(json['meta']['total']).to eq(5)
      expect(json['meta']['pages']).to eq(3)
    end

    it 'is accessible without auth' do
      get '/api/v1/mejas'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/v1/mejas/:id' do
    it 'returns a specific meja' do
      meja = create(:meja, nomor_meja: 1, status: :tersedia)
      get "/api/v1/mejas/#{meja.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['nomor_meja']).to eq(1)
    end

    it 'returns 404 for non-existent meja' do
      get '/api/v1/mejas/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end