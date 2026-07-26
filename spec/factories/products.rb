FactoryBot.define do
  factory :product do
    category { nil }
    sequence(:name) { |n| "Product #{n}" }
    price { 10000 }
    stock { 10 }
    product_type { :cafe }
    status { :active }
  end
end