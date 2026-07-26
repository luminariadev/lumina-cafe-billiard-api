FactoryBot.define do
  factory :transaksi_item do
    transaksi
    product
    quantity { 2 }
    price { nil }
    subtotal { nil }
    notes { "" }
  end
end