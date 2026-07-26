require 'rails_helper'

RSpec.describe Meja, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nomor_meja) }
    it { should validate_uniqueness_of(:nomor_meja) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(tersedia: 0, terpakai: 1, maintenance: 2) }
  end

  describe 'scopes' do
    let!(:meja_tersedia) { create(:meja, nomor_meja: 1, status: :tersedia) }
    let!(:meja_terpakai) { create(:meja, nomor_meja: 2, status: :terpakai) }
    let!(:meja_maintenance) { create(:meja, nomor_meja: 3, status: :maintenance) }

    it 'tersedia scope returns available tables' do
      expect(Meja.tersedia).to include(meja_tersedia)
      expect(Meja.tersedia).not_to include(meja_terpakai)
    end
  end
end
