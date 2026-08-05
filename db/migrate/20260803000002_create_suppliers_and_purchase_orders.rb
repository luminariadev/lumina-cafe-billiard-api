class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false
      t.string :contact_person
      t.string :phone
      t.string :email
      t.text :address
      t.timestamps
    end

    create_table :purchase_orders do |t|
      t.references :supplier, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.decimal :price_per_unit, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: 'pending' # pending, ordered, received, cancelled
      t.text :notes
      t.date :order_date
      t.date :received_date
      t.timestamps
    end
  end
end
