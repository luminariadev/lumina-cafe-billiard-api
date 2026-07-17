class CreateTransaksis < ActiveRecord::Migration[8.1]
  def change
    create_table :transaksis do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meja, null: false, foreign_key: true
      t.string :kode_transaksi
      t.string :customer_name
      t.integer :transaksi_type
      t.decimal :total_amount
      t.integer :status
      t.integer :payment_method
      t.datetime :jam_mulai
      t.datetime :jam_selesai

      t.timestamps
    end
    add_index :transaksis, :kode_transaksi, unique: true
  end
end
