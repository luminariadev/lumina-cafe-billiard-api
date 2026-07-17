class TransaksiItem < ApplicationRecord
  belongs_to :transaksi
  belongs_to :product
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  before_validation :set_price_subtotal, on: :create

  private
  def set_price_subtotal
    self.price ||= product&.price || 0
    self.subtotal = (quantity || 1) * price
  end
end
