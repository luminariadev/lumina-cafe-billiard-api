class LoyaltyPoint < ApplicationRecord
  has_many :loyalty_point_transactions

  validates :phone, presence: true, uniqueness: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }

  def tier
    LoyaltyTier.tier_for(points)
  end
end
