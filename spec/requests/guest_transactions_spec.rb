require 'rails_helper'

RSpec.describe 'GuestTransactions', type: :request do
  describe 'POST /api/v1/guest_transactions/billiard' do
    let!(:meja) { create(:meja, nomor_meja: 1, status: :tersedia) }
    let(:valid_params) do
      {
        customer_name: 'John Doe',
        customer_phone: '08123456789',
        nomor_meja: 1,
        durasi_jam: 2
      }
    end

    it 'creates a billiard booking' do
      post '/api/v1/guest_transactions/billiard', params: valid_params, as: :json
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['kode_transaksi']).to start_with('GB')
      expect(json['total_amount']).to eq(50_000)
    end

    it 'rejects invalid name' do
      post '/api/v1/guest_transactions/billiard', params: valid_params.merge(customer_name: 'A'), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects invalid phone' do
      post '/api/v1/guest_transactions/billiard', params: valid_params.merge(customer_phone: '123'), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects unavailable table' do
      meja.update!(status: :terpakai)
      post '/api/v1/guest_transactions/billiard', params: valid_params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Meja tidak tersedia')
    end
  end

  describe 'GET /api/v1/guest_transactions/history' do
    let!(:transaksi) { create(:transaksi, customer_phone: '08123456789', transaksi_type: :billiard) }

    it 'returns guest transactions by phone' do
      get '/api/v1/guest_transactions/history?phone=08123456789'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.first['kode_transaksi']).to eq(transaksi.kode_transaksi)
    end

    it 'returns empty array for unknown phone' do
      get '/api/v1/guest_transactions/history?phone=08111111111'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end
  end

  describe 'POST /api/v1/guest_transactions/cafe' do
    let!(:product) { create(:product, name: 'Kopi', price: 15000, stock: 10) }

    it 'creates a cafe order with items' do
      post '/api/v1/guest_transactions/cafe', params: {
        customer_name: 'John Doe',
        customer_phone: '08123456789',
        items: { product.id.to_s => 2 },
        payment_method: 'qris'
      }, as: :json
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['kode_transaksi']).to start_with('GC')
    end
  end
end
