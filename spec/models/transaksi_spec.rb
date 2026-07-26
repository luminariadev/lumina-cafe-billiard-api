require 'rails_helper'

RSpec.describe Transaksi, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:meja).optional }
    it { should have_many(:transaksi_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:kode_transaksi) }
    it { should validate_uniqueness_of(:kode_transaksi) }
    it { should define_enum_for(:status).with_values(pending: 0, dibayar: 1, batal: 2) }
  end

  describe 'generate_kode_transaksi' do
    it 'generates unique code with GB prefix for billiard' do
      transaksi = build(:transaksi, transaksi_type: :billiard, kode_transaksi: nil)
      transaksi.generate_kode_transaksi
      expect(transaksi.kode_transaksi).to start_with('GB')
    end

    it 'generates unique code with GC prefix for cafe' do
      transaksi = build(:transaksi, transaksi_type: :cafe, kode_transaksi: nil)
      transaksi.generate_kode_transaksi
      expect(transaksi.kode_transaksi).to start_with('GC')
    end

    it 'does not override existing code' do
      transaksi = build(:transaksi, kode_transaksi: 'EXISTING')
      transaksi.generate_kode_transaksi
      expect(transaksi.kode_transaksi).to eq('EXISTING')
    end
  end

  describe 'scopes' do
    let!(:transaksi_hari_ini) { create(:transaksi, jam_mulai: Time.current) }
    let!(:transaksi_kemarin) { create(:transaksi, jam_mulai: 1.day.ago) }

    it 'today scope only includes today records' do
      expect(Transaksi.today).to include(transaksi_hari_ini)
      expect(Transaksi.today).not_to include(transaksi_kemarin)
    end
  end
end
