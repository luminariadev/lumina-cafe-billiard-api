require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:products) }
  end

  describe 'product_count' do
    let!(:category) { create(:category) }
    let!(:product) { create(:product, category: category) }

    it 'returns associated product count' do
      expect(category.products.count).to eq(1)
    end
  end
end
