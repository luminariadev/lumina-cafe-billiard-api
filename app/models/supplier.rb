class Supplier < ApplicationRecord
  has_many :purchase_orders
  validates :name, presence: true, uniqueness: true
end
