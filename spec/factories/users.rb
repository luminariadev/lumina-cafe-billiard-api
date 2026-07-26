FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "user_#{n}_#{SecureRandom.hex(4)}" }
    sequence(:email) { |n| "user#{n}_#{SecureRandom.hex(4)}@lumina.local" }
    password { 'password123' }
    role { :kasir_billiard }
    active { true }
  end
end