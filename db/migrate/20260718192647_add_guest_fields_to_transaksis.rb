class AddGuestFieldsToTransaksis < ActiveRecord::Migration[8.1]
  def change
    add_column :transaksis, :customer_phone, :string
    add_column :transaksis, :qris_string, :string
    add_column :transaksis, :qr_expires_at, :datetime
  end
end