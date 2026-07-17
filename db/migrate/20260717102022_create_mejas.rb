class CreateMejas < ActiveRecord::Migration[8.1]
  def change
    create_table :mejas do |t|
      t.integer :nomor_meja
      t.integer :status
      t.text :keterangan

      t.timestamps
    end
  end
end
