# Lumina Cafe Billiard — Backend API

[![CI](https://github.com/luminariadev/lumina-cafe-billiard-api/actions/workflows/ci.yml/badge.svg)](https://github.com/luminariadev/lumina-cafe-billiard-api/actions)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits)](https://conventionalcommits.org)
[![Ruby](https://img.shields.io/badge/Ruby-3.4-red?logo=ruby)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.1-red?logo=rubyonrails)](https://rubyonrails.org)

Rails 8 API untuk sistem manajemen Cafe & Billiard **Lumina**. Berjalan di Docker container dengan PostgreSQL 16.

---

## Tech Stack

- **Framework:** Rails 8.1 (API-only mode)
- **Ruby:** 3.4.10
- **Database:** PostgreSQL 16
- **Auth:** JWT (24h expiry)
- **Container:** Docker + Docker Compose
- **Web server:** Puma 8

---

## Quick Start

```bash
# Clone & masuk
git clone https://github.com/luminariadev/lumina-cafe-billiard-api.git
cd lumina-cafe-billiard-api

# Jalankan container
docker compose up -d

# Setup database & seed
docker compose exec api bundle exec rails db:create db:migrate db:seed

# API aktif di http://localhost:3000/api/v1
```

> **Port:** 3000 (host) → 3000 (container)  
> **PostgreSQL:** localhost:5433 (host) → 5432 (container)

---

## Project Structure

```
app/
├── controllers/api/v1/
│   ├── auth_controller.rb           # Login + JWT
│   ├── products_controller.rb       # CRUD produk (index public)
│   ├── mejas_controller.rb          # CRUD meja (index public)
│   ├── transaksis_controller.rb     # Transaksi auth (CRUD + pay + report + cafe_pos)
│   ├── guest_transactions_controller.rb  # Transaksi guest (tanpa auth)
│   ├── categories_controller.rb     # CRUD kategori
│   └── reports_controller.rb        # Laporan (read-only, auth required)
├── models/
│   ├── user.rb                      # User (admin/kasir_billiard/kasir_cafe)
│   ├── product.rb                   # Produk makanan/minuman
│   ├── meja.rb                      # Meja billiard
│   ├── transaksi.rb                 # Transaksi (billiard/cafe)
│   ├── transaksi_item.rb            # Item dalam transaksi cafe
│   └── category.rb                  # Kategori produk
└── services/
    └── json_web_token.rb            # JWT encode/decode
```

---

## API Endpoints

### Public (No Auth)
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/products` | Daftar semua produk |
| `GET` | `/api/v1/products/:id` | Detail produk |
| `GET` | `/api/v1/mejas` | Daftar semua meja |
| `GET` | `/api/v1/mejas/:id` | Detail meja |
| `GET` | `/api/v1/configs` | Konfigurasi aplikasi (harga, jam operasional, dll.) |

### Guest (No Auth, Transaksi)
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/guest_transactions/billiard` | Booking meja billiard |
| `POST` | `/api/v1/guest_transactions/cafe` | Order cafe (makanan/minuman) |
| `GET` | `/api/v1/guest_transactions/:id/status` | Cek status pembayaran |
| `POST` | `/api/v1/guest_transactions/:id/pay` | Simulasi pembayaran QRIS |
| `GET` | `/api/v1/guest_transactions/history` | Riwayat transaksi guest berdasarkan nomor HP |

**Billiard booking body:**
```json
{
  "nomor_meja": 1,
  "durasi_jam": 2,
  "customer_name": "John Doe",
  "customer_phone": "08123456789"
}
```

**Cafe order body:**
```json
{
  "customer_name": "John Doe",
  "customer_phone": "08123456789",
  "items": { "4": 2, "10": 1 },
  "payment_method": "qris"
}
```

### Authenticated (Bearer Token)
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/auth/login` | Login (email + password) |
| `GET` | `/api/v1/auth/me` | Profil user saat ini |
| `GET` / `POST` | `/api/v1/transaksis` | CRUD transaksi (paginated: `?page=&per_page=`) |
| `GET` / `PATCH` / `DELETE` | `/api/v1/transaksis/:id` | Detail / update / hapus transaksi |
| `POST` | `/api/v1/transaksis/:id/pay` | Konfirmasi pembayaran |
| `POST` | `/api/v1/transaksis/cafe_pos` | POS cafe (kasir) |
| `GET` | `/api/v1/transaksis/report` | Laporan transaksi |
| `GET` | `/api/v1/reports` | Laporan agregat |
| `CRUD` | `/api/v1/products` | Manajemen produk |
| `CRUD` | `/api/v1/categories` | Manajemen kategori |
| `CRUD` | `/api/v1/mejas` | Manajemen meja |

---

## Roles & Access

| Role | Scope |
|------|-------|
| `admin` | Full akses semua fitur |
| `kasir_billiard` | POS billiard, transaksi billiard, dashboard |
| `kasir_cafe` | POS cafe, transaksi cafe, dashboard |

Guest transaction endpoints (`/api/v1/guest_transactions/*`) tidak memerlukan auth.

---

## Credentials (Dev/Seed)

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@lumina.local | admin123 |
| Kasir Billiard | kasir.billiard@lumina.local | kasir123 |
| Kasir Cafe | kasir.cafe@lumina.local | kasir123 |

---

## Docker Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Rails console
docker compose exec api bundle exec rails c

# Run migrations
docker compose exec api bundle exec rails db:migrate

# Re-seed
docker compose exec api bundle exec rails db:seed

# View logs
docker compose logs -f api
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DATABASE_HOST` | `db` | Host PostgreSQL container |
| `DATABASE_PORT` | `5432` | Port PostgreSQL |
| `DATABASE_USER` | `lumina` | User PostgreSQL |
| `DATABASE_PASSWORD` | *(terisi)* | Password PostgreSQL |
| `DATABASE_NAME` | `lumina_cafe_billiard_dev` | Nama database |
| `JWT_SECRET` | *(random)* | Secret key JWT |
| `RAILS_ENV` | `development` | Environment Rails |

---

## Development

```bash
# Create new migration
docker compose exec api bundle exec rails g migration NamaMigration

# Run tests
docker compose exec api bundle exec rails test

# Check routes
docker compose exec api bundle exec rails routes
```
2026-07-29 19:42
# Last synced: 2026-07-30 17:41:01 WIB
# Manual sync: 2026-07-30 17:45:13 WIB
