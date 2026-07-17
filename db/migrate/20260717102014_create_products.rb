class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.decimal :price
      t.integer :stock
      t.integer :product_type
      t.integer :status

      t.timestamps
    end
  end
end
