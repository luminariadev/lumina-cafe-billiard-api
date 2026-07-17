class ChangeMejaIdNullableOnTransaksis < ActiveRecord::Migration[8.1]
  def change
    change_column_null :transaksis, :meja_id, true
  end
end