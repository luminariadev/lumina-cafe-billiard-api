FactoryBot.define do
  factory :meja do
    sequence(:nomor_meja) { |n| n }
    status { :tersedia }
    keterangan { "" }
  end
end