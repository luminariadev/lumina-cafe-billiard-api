require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
  end

  describe 'associations' do
    it { should have_many(:transaksis).dependent(:restrict_with_error) }
  end

  describe 'enum role' do
    it { should define_enum_for(:role).with_values(admin: 0, kasir_billiard: 1, kasir_cafe: 2) }
  end

  describe '#admin?' do
    it 'returns true for admin role' do
      user = build(:user, role: :admin)
      expect(user.admin?).to be true
    end

    it 'returns false for non-admin role' do
      user = build(:user, role: :kasir_billiard)
      expect(user.admin?).to be false
    end
  end

  describe '#kasir_billiard?' do
    it 'returns true for kasir_billiard role' do
      user = build(:user, role: :kasir_billiard)
      expect(user.kasir_billiard?).to be true
    end
  end

  describe '#kasir_cafe?' do
    it 'returns true for kasir_cafe role' do
      user = build(:user, role: :kasir_cafe)
      expect(user.kasir_cafe?).to be true
    end
  end

  describe '#kasir?' do
    it 'returns true for kasir_billiard' do
      user = build(:user, role: :kasir_billiard)
      expect(user.kasir?).to be true
    end

    it 'returns true for kasir_cafe' do
      user = build(:user, role: :kasir_cafe)
      expect(user.kasir?).to be true
    end

    it 'returns false for admin' do
      user = build(:user, role: :admin)
      expect(user.kasir?).to be false
    end
  end

  describe 'password presence' do
    it 'requires password on create' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'accepts valid password' do
      user = build(:user, password: 'validpassword')
      expect(user).to be_valid
    end
  end
end