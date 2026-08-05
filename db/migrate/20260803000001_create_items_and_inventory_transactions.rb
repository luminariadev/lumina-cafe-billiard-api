class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :unit, null: false # e.g., 'kg', 'liter', 'pcs'
      t.decimal :stock, precision: 10, scale: 2, default: 0.0
      t.decimal :min_stock_alert, precision: 10, scale: 2, default: 0.0
      t.timestamps
    end

    create_table :inventory_transactions do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true # User (admin/kasir) who made the transaction
      t.string :type, null: false # 'in' or 'out'
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.text :notes
      t.timestamps
    end
  end
end
