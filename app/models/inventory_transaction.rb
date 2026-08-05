class InventoryTransaction < ApplicationRecord
  belongs_to :item
  belongs_to :user # Refers to admin/kasir who initiated the transaction

  enum transaction_type: { in: 'in', out: 'out' }

  validates :item_id, presence: true
  validates :user_id, presence: true
  validates :transaction_type, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  after_save :update_item_stock

  private

  def update_item_stock
    if transaction_type == 'in'
      item.increment!(:stock, quantity)
    elsif transaction_type == 'out'
      item.decrement!(:stock, quantity)
    end
  end
end
