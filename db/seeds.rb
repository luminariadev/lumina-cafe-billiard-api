puts "=== SEEDING DATA ==="

# Users
admin = User.find_or_create_by!(username: "admin") do |u|
  u.name = "Administrator"
  u.email = "admin@lumina.local"
  u.password = "admin123"
  u.role = :admin
end

kasir1 = User.find_or_create_by!(username: "kasir_billiard") do |u|
  u.name = "Kasir Billiard"
  u.email = "kasir.billiard@lumina.local"
  u.password = "kasir123"
  u.role = :kasir_billiard
end

kasir2 = User.find_or_create_by!(username: "kasir_cafe") do |u|
  u.name = "Kasir Cafe"
  u.email = "kasir.cafe@lumina.local"
  u.password = "kasir123"
  u.role = :kasir_cafe
end

# Categories
cat_minuman = Category.find_or_create_by!(name: "Minuman")
cat_makanan = Category.find_or_create_by!(name: "Makanan")
cat_snack = Category.find_or_create_by!(name: "Snack")
cat_billiard = Category.find_or_create_by!(name: "Paket Billiard")

# Products (cafe - minuman)
[
  { name: "Es Jeruk", price: 8000, category: cat_minuman, product_type: :minuman, stock: 100, status: :active },
  { name: "Es Teh Manis", price: 5000, category: cat_minuman, product_type: :minuman, stock: 150, status: :active },
  { name: "Kopi Hitam", price: 12000, category: cat_minuman, product_type: :minuman, stock: 80, status: :active },
  { name: "Cappuccino", price: 18000, category: cat_minuman, product_type: :minuman, stock: 60, status: :active },
  { name: "Wedang Jahe", price: 15000, category: cat_minuman, product_type: :minuman, stock: 40, status: :active },
  { name: "Es Coklat", price: 15000, category: cat_minuman, product_type: :minuman, stock: 50, status: :active },
  { name: "Matcha Latte", price: 22000, category: cat_minuman, product_type: :minuman, stock: 45, status: :active },
].each { |p| Product.find_or_create_by!(name: p[:name]) { |pr| pr.assign_attributes(p) } }

# Products (cafe - makanan)
[
  { name: "Nasi Goreng", price: 25000, category: cat_makanan, product_type: :makanan, stock: 30, status: :active },
  { name: "Mie Goreng", price: 22000, category: cat_makanan, product_type: :makanan, stock: 35, status: :active },
  { name: "Ayam Geprek", price: 28000, category: cat_makanan, product_type: :makanan, stock: 25, status: :active },
  { name: "Indomie Goreng", price: 15000, category: cat_makanan, product_type: :makanan, stock: 50, status: :active },
  { name: "Roti Bakar", price: 18000, category: cat_makanan, product_type: :makanan, stock: 20, status: :active },
].each { |p| Product.find_or_create_by!(name: p[:name]) { |pr| pr.assign_attributes(p) } }

# Products (cafe - snack)
[
  { name: "Pisang Goreng", price: 12000, category: cat_snack, product_type: :makanan, stock: 40, status: :active },
  { name: "Tahu Crispy", price: 10000, category: cat_snack, product_type: :makanan, stock: 45, status: :active },
  { name: "French Fries", price: 15000, category: cat_snack, product_type: :makanan, stock: 30, status: :active },
  { name: "Chicken Wings", price: 25000, category: cat_snack, product_type: :makanan, stock: 25, status: :active },
].each { |p| Product.find_or_create_by!(name: p[:name]) { |pr| pr.assign_attributes(p) } }

# Products (billiard)
[
  { name: "Paket 1 Jam", price: 30000, category: cat_billiard, product_type: :billiard, stock: 999, status: :active },
  { name: "Paket 2 Jam", price: 55000, category: cat_billiard, product_type: :billiard, stock: 999, status: :active },
  { name: "Paket 3 Jam", price: 75000, category: cat_billiard, product_type: :billiard, stock: 999, status: :active },
  { name: "Paket Harian (8 jam)", price: 180000, category: cat_billiard, product_type: :billiard, stock: 999, status: :active },
  { name: "Paket Mingguan", price: 700000, category: cat_billiard, product_type: :billiard, stock: 999, status: :active },
].each { |p| Product.find_or_create_by!(name: p[:name]) { |pr| pr.assign_attributes(p) } }

# Make ALL products active (fix seed legacy issue)
Product.where.not(status: :active).update_all(status: :active)

# Mejas - set all available by default
(1..10).each do |n|
  Meja.find_or_create_by!(nomor_meja: n) do |m|
    m.status = :tersedia unless m.persisted?
    m.keterangan = "Meja Billiard #{n}"
  end
end
# Reset all meja to tersedia
Meja.update_all(status: :tersedia)

puts "=== SEED DONE ==="
puts "Admin: admin / admin123"
puts "Kasir Billiard: kasir_billiard / kasir123"
puts "Kasir Cafe: kasir_cafe / kasir123"
puts "Products: #{Product.count} items (all active)"
puts "Mejas: #{Meja.count} meja (all tersedia)"