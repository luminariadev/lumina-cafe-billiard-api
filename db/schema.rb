# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_17_163943) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "mejas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "keterangan"
    t.integer "nomor_meja"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price"
    t.integer "product_type"
    t.integer "status"
    t.integer "stock"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "transaksi_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.decimal "price"
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "subtotal"
    t.bigint "transaksi_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_transaksi_items_on_product_id"
    t.index ["transaksi_id"], name: "index_transaksi_items_on_transaksi_id"
  end

  create_table "transaksis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.datetime "jam_mulai"
    t.datetime "jam_selesai"
    t.string "kode_transaksi"
    t.bigint "meja_id"
    t.integer "payment_method"
    t.integer "status"
    t.decimal "total_amount"
    t.integer "transaksi_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["kode_transaksi"], name: "index_transaksis_on_kode_transaksi", unique: true
    t.index ["meja_id"], name: "index_transaksis_on_meja_id"
    t.index ["user_id"], name: "index_transaksis_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "products", "categories"
  add_foreign_key "transaksi_items", "products"
  add_foreign_key "transaksi_items", "transaksis"
  add_foreign_key "transaksis", "mejas"
  add_foreign_key "transaksis", "users"
end
