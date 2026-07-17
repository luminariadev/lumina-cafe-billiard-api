FactoryBot.define do
  factory :transaksi do
    user { nil }
    meja { nil }
    kode_transaksi { "MyString" }
    customer_name { "MyString" }
    transaksi_type { 1 }
    total_amount { "9.99" }
    status { 1 }
    payment_method { 1 }
    jam_mulai { "2026-07-17 10:20:30" }
    jam_selesai { "2026-07-17 10:20:30" }
  end
end
