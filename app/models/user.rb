class User < ApplicationRecord
  has_secure_password

  has_many :transaksis, dependent: :restrict_with_error

  enum :role, { admin: 0, kasir_billiard: 1, kasir_cafe: 2 }

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: true

  def admin? = role == "admin"
  def kasir_billiard? = role == "kasir_billiard"
  def kasir_cafe? = role == "kasir_cafe"
end
