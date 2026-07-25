# Changelog

## v1.0.0 (2026-07-25)

### ✨ Features
- **Auth**: JWT login with admin/kasir billiard/kasir cafe roles, 2FA-ready
- **Meja**: CRUD + status management (tersedia/terpakai/maintenance)
- **Products**: CRUD with categories, stock tracking
- **Categories**: CRUD with product count
- **Transaksi**: Billiard booking, cafe order, payment, QRIS mock
- **Guest Transactions**: Public booking without login — billiard & cafe
- **Guest History**: `GET /guest_transactions/history?phone=` — view past orders
- **Config**: `GET /config` — dynamic pricing, operating hours, payment methods
- **Reports**: Daily revenue breakdown (billiard vs cafe)
- **Pagination**: Products, Mejas, Transaksis with page/per_page/meta
- **Auto-expire QRIS**: `ExpireQrisJob` via Solid Queue every 5 minutes
- **CORS**: Configurable via `CORS_ORIGINS` env, restricted by default

### 🐛 Fixes
- Meja `show` endpoint public access (skip auth)
- Clean AI agent configs from repo
- Double query elimination in meja status

### 🧰 Technical
- Rails 8.1, Ruby 3.4.10, PostgreSQL
- Solid Queue for background jobs
- Rack::CORS with env-based origins
- Conventional commits standard
- Docker compose ready
