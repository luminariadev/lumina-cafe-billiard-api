class Meja < ApplicationRecord
  has_many :transaksis, dependent: :restrict_with_error
  enum :status, { tersedia: 0, terpakai: 1, maintenance: 2 }
  validates :nomor_meja, presence: true, uniqueness: true
end
