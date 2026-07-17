class CreateTransaksiItems < ActiveRecord::Migration[8.1]
  def change
    create_table :transaksi_items do |t|
      t.references :transaksi, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.decimal :subtotal
      t.text :notes

      t.timestamps
    end
  end
end
