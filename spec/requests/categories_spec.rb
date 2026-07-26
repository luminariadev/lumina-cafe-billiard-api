require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:admin) { create(:user, username: 'admin', password: 'admin123', role: :admin) }
  let(:token) do
    post '/api/v1/auth/login', params: { username: 'admin', password: 'admin123' }, as: :json
    JSON.parse(response.body)['token']
  end

  describe 'GET /api/v1/categories' do
    it 'returns all categories' do
      create_list(:category, 3)
      get '/api/v1/categories'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /api/v1/categories/:id' do
    it 'returns a category with product count' do
      category = create(:category, name: 'Minuman')
      create(:product, name: 'Kopi', category: category)
      get "/api/v1/categories/#{category.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Minuman')
      expect(json['product_count']).to eq(1)
    end
  end

  describe 'POST /api/v1/categories' do
    it 'creates a category when admin' do
      post '/api/v1/categories',
        params: { category: { name: 'Minuman', description: 'Minuman dingin & panas' } },
        headers: { 'Authorization' => "Bearer #{token}" },
        as: :json
      expect(response).to have_http_status(:created)
      expect(Category.count).to eq(1)
    end

    it 'rejects non-admin' do
      kasir = create(:user, username: 'kasir', password: 'kasir123', role: :kasir_billiard)
      post '/api/v1/auth/login', params: { username: 'kasir', password: 'kasir123' }, as: :json
      kasir_token = JSON.parse(response.body)['token']

      post '/api/v1/categories',
        params: { category: { name: 'Minuman' } },
        headers: { 'Authorization' => "Bearer #{kasir_token}" },
        as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT /api/v1/categories/:id' do
    it 'updates a category' do
      category = create(:category, name: 'Minuman')
      put "/api/v1/categories/#{category.id}",
        params: { category: { description: 'Updated desc' } },
        headers: { 'Authorization' => "Bearer #{token}" },
        as: :json
      expect(response).to have_http_status(:ok)
      expect(category.reload.description).to eq('Updated desc')
    end
  end

  describe 'DELETE /api/v1/categories/:id' do
    it 'deletes a category' do
      category = create(:category)
      delete "/api/v1/categories/#{category.id}",
        headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status(:no_content)
      expect(Category.count).to eq(0)
    end
  end
end