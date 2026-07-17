FactoryBot.define do
  factory :product do
    category { nil }
    name { "MyString" }
    price { "9.99" }
    stock { 1 }
    product_type { 1 }
    status { 1 }
  end
end
