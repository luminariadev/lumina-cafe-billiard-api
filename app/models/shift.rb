class Shift < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :clock_in, presence: true

  scope :active, -> { where(clock_out: nil) }
  scope :for_date, ->(date) { where(clock_in: date.beginning_of_day..date.end_of_day) }

  def duration_hours
    return nil unless clock_out
    ((clock_out - clock_in) / 3600.0).round(2)
  end
end
