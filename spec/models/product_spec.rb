require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:category).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'scopes' do
    let!(:cafe_product) { create(:product, name: 'Kopi', product_type: :cafe, stock: 10) }
    let!(:billiard_product) { create(:product, name: 'Sewa Meja', product_type: :billiard, stock: 0) }

    it 'by type filter works' do
      expect(Product.cafe).to include(cafe_product)
      expect(Product.cafe).not_to include(billiard_product)
    end
  end
end
