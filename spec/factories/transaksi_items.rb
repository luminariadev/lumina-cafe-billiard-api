FactoryBot.define do
  factory :transaksi_item do
    transaksi { nil }
    product { nil }
    quantity { 1 }
    price { "9.99" }
    subtotal { "9.99" }
    notes { "MyText" }
  end
end
