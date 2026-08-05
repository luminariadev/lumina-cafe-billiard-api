class CreateLoyaltyTables < ActiveRecord::Migration[7.0]
  def change
    create_table :loyalty_tiers do |t|
      t.string :name, null: false, default: 'bronze'
      t.integer :min_points, null: false, default: 0
      t.decimal :discount_percent, precision: 5, scale: 2, default: 0.0
      t.timestamps
    end

    create_table :loyalty_points do |t|
      t.string :phone, null: false
      t.integer :points, null: false, default: 0
      t.timestamps
    end

    create_table :loyalty_point_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transaksi, null: false, foreign_key: true
      t.integer :points, null: false
      t.string :action, null: false # earn / redeem
      t.text :notes
      t.timestamps
    end
  end
end
