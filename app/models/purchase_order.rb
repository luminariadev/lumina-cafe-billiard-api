class PurchaseOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :item

  enum status: { pending: 'pending', ordered: 'ordered', received: 'received', cancelled: 'cancelled' }

  validates :supplier_id, presence: true
  validates :item_id, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price_per_unit, numericality: { greater_than_or_equal_to: 0 }

  after_update :handle_received

  private

  def handle_received
    if status == 'received' && saved_change_to_status? && saved_change_to_status?[0] != 'received'
      # Add stock to item when PO is received
      item.increment!(:stock, quantity)
    end
  end
end
