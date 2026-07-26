FactoryBot.define do
  factory :transaksi do
    user { nil }
    meja { nil }
    kode_transaksi { nil }
    customer_name { "John Doe" }
    transaksi_type { :billiard }
    total_amount { 50000 }
    status { :pending }
    payment_method { :cash }
    jam_mulai { Time.current }
    jam_selesai { nil }
  end
end