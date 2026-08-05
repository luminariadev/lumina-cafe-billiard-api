class Item < ApplicationRecord
  has_many :inventory_transactions
  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :min_stock_alert, numericality: { greater_than_or_equal_to: 0 }
end
