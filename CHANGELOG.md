# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0] - 2026-07-25

### Added
- **`ExpireQrisJob`** — background job that auto-expires pending QRIS transactions after their `qr_expires_at` time; scheduled every 5 minutes via Solid Queue recurring jobs
- **`GET /api/v1/guest_transactions/history?phone=`** — guest transaction history endpoint (no auth required); returns last 20 transactions for a phone number
- **`GET /api/v1/configs`** — app configuration endpoint (no auth required); returns `price_per_hour`, `operating_hours`, `payment` methods
- Booking validation on guest endpoints — `customer_name` min 2 chars, `customer_phone` 8-15 digits
- Pagination on `GET /products` and `GET /mejas` (page/limit params)
- Solid Queue support (Rails 8 built-in) with recurring job schedule in `config/recurring.yml`

### Changed
- `GET /mejas` now includes `status` and `active` fields as strings for guest access
- `POST /transaksis/:id/pay` no longer requires admin role (kasir can access)

### Fixed
- `GET /mejas/:id` had double DB query — reduced to single query using `find_by`
- `GET /mejas/:id` was protected by `authorize_request` (should be public) — removed from `skip_before_action`
- `GET /reports` no longer requires admin — kasir roles can access

### Dependencies
- Bumped `jwt` gem to address security advisories

---

## [v1.0.0-alpha] - 2026-07-24

### Added (Initial Release)
- JWT authentication (`POST /auth/login`, `GET /auth/me`)
- Role-based access control (admin, kasir_billiard, kasir_cafe)
- Meja (table) CRUD — `GET/POST /mejas`, `GET/PUT/DELETE /mejas/:id`
- Product CRUD — `GET/POST /products`, `GET/PUT/DELETE /products/:id`
- Category CRUD — `GET/POST /categories`, `GET/PUT/DELETE /categories/:id`
- Transaction management — `POST /transaksis`, `POST /transaksis/:id/pay`, `POST /transaksis/cafe_pos`
- Report endpoint — `GET /transaksis/report`
- Guest billiard booking — `POST /guest_transactions/billiard` (no auth)
- Guest cafe order — `POST /guest_transactions/cafe` (no auth)
- QRIS mock payment simulation — `GET /guest_transactions/:id/status`, `POST /guest_transactions/:id/pay`
- `Transaksi` model with enum for type (billiard/cafe), status (pending/dibayar/batal), payment_method
- `kode_transaksi` auto-generation (prefix GB/GC + date + sequence)
- QR expiration (5 minutes) via `generate_qris`
- GitHub Actions CI/CD — lint, test, build checks
- Commitlint with Conventional Commits rules
- `.gitignore` blocks all AI agent config files (AGENTS.md, CLAUDE.md, CURSOR.md, etc.)