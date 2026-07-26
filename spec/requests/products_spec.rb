require 'rails_helper'

RSpec.describe 'Products', type: :request do
  describe 'GET /api/v1/products' do
    it 'returns all products' do
      create(:product, name: 'Kopi', price: 15000, product_type: :cafe)
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(1)
      expect(json['data'].first['name']).to eq('Kopi')
    end

    it 'filters by product_type' do
      create(:product, name: 'Kopi', product_type: :cafe)
      create(:product, name: 'Sewa Meja', product_type: :billiard)
      get '/api/v1/products', params: { type: 'cafe' }
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(1)
      expect(json['data'].first['product_type']).to eq('cafe')
    end

    it 'returns paginated results' do
      create_list(:product, 10)
      get '/api/v1/products', params: { page: 1, per_page: 3 }
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(3)
      expect(json['meta']['pages']).to eq(4)
    end

    it 'is accessible without auth' do
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/v1/products/:id' do
    it 'returns a specific product' do
      product = create(:product, name: 'Kopi', price: 15000)
      get "/api/v1/products/#{product.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Kopi')
    end
  end
end