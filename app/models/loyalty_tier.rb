class LoyaltyTier < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :min_points, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.tier_for(points)
    where('min_points <= ?', points).order(min_points: :desc).first
  end
end
