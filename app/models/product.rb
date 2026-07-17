class Product < ApplicationRecord
  belongs_to :category
  has_many :transaksi_items, dependent: :restrict_with_error
  enum :product_type, { billiard: 0, cafe: 1, minuman: 2, makanan: 3 }
  enum :status, { active: 0, inactive: 1 }
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where(status: :active).where("stock > 0") }
  scope :low_stock, -> { where(status: :active).where("stock <= ?", 5) }
end
