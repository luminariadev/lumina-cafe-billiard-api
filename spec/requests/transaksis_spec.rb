require 'rails_helper'

RSpec.describe 'Transaksis', type: :request do
  let(:admin) { create(:user, username: 'admin', password: 'admin123', role: :admin) }
  let(:token) do
    post '/api/v1/auth/login', params: { username: 'admin', password: 'admin123' }, as: :json
    JSON.parse(response.body)['token']
  end

  describe 'GET /api/v1/transaksis' do
    it 'returns paginated transactions' do
      create_list(:transaksi, 5)
      get '/api/v1/transaksis',
        headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(5)
      expect(json['meta']).to be_present
    end

    it 'requires authentication' do
      get '/api/v1/transaksis'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v1/transaksis/:id' do
    it 'returns a transaction' do
      transaksi = create(:transaksi)
      get "/api/v1/transaksis/#{transaksi.id}",
        headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['kode_transaksi']).to be_present
    end
  end

  describe 'PUT /api/v1/transaksis/:id/pay' do
    it 'marks a transaction as paid' do
      transaksi = create(:transaksi, status: :pending)
      post "/api/v1/transaksis/#{transaksi.id}/pay",
        params: { payment_method: 'cash' },
        headers: { 'Authorization' => "Bearer #{token}" },
        as: :json
      expect(response).to have_http_status(:ok)
      expect(transaksi.reload.status).to eq('dibayar')
    end
  end

  describe 'GET /api/v1/transaksis/report' do
    it 'returns daily report' do
      create(:transaksi, status: :dibayar, total_amount: 50000)
      get '/api/v1/transaksis/report',
        headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['total_all']).to eq(50000)
    end
  end
end