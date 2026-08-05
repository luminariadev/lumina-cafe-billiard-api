class LoyaltyPointTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :transaksi

  enum action: { earn: 'earn', redeem: 'redeem' }

  validates :user_id, presence: true
  validates :transaksi_id, presence: true
  validates :points, presence: true
  validates :action, presence: true

  after_save :update_loyalty_balance

  private

  def update_loyalty_balance
    phone = transaksi&.customer_phone || user&.phone
    return if phone.blank?

    loyalty = LoyaltyPoint.find_or_create_by(phone: phone)
    if action == 'earn'
      loyalty.increment!(:points, points)
    elsif action == 'redeem'
      loyalty.decrement!(:points, points)
    end
  end
end
