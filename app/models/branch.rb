class Branch < ApplicationRecord
  has_many :mejas
  has_many :products
  validates :name, presence: true, uniqueness: true
end
