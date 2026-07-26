require 'rails_helper'

RSpec.describe TransaksiItem, type: :model do
  describe 'associations' do
    it { should belong_to(:transaksi) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe '#set_price_subtotal' do
    let!(:product) { create(:product, price: 15000) }
    let!(:transaksi) { create(:transaksi) }

    it 'sets price from product if not provided' do
      item = build(:transaksi_item, transaksi: transaksi, product: product, price: nil, quantity: 2)
      item.valid?
      expect(item.price).to eq(15000)
    end

    it 'sets subtotal as quantity * price' do
      item = build(:transaksi_item, transaksi: transaksi, product: product, quantity: 3)
      item.valid?
      expect(item.subtotal).to eq(45000)
    end

    it 'uses provided price over product price' do
      item = build(:transaksi_item, transaksi: transaksi, product: product, price: 20000, quantity: 1)
      item.valid?
      expect(item.price).to eq(20000)
      expect(item.subtotal).to eq(20000)
    end

    it 'defaults to 0 price when product has no price' do
      product_no_price = create(:product, price: nil)
      item = build(:transaksi_item, transaksi: transaksi, product: product_no_price, quantity: 1)
      item.valid?
      expect(item.price).to eq(0)
      expect(item.subtotal).to eq(0)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      product = create(:product, price: 10000)
      transaksi = create(:transaksi)
      item = build(:transaksi_item, transaksi: transaksi, product: product, quantity: 2)
      expect(item).to be_valid
    end
  end
end