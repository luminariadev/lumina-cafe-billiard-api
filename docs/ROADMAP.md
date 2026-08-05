# Lumina Cafe Billiard — Roadmap v2.0 "Production Ready"

**Goal:** Dari prototype jadi production-grade — payment real, real-time, fitur lengkap.

---

## ✅ v1.0 Done
- Backend: Auth JWT, CRUD Meja/Products, Transaksi billiard & cafe, QRIS mock, Reports
- Web: Dashboard, POS, CRUD, Login, Dark theme (#131313 / #6bfb9a), Responsive
- Mobile: All 7 screens (Home→Book→Cafe→Cart→Payment→Status), Dark glassmorphism, BottomTabNav
- Testing + CI/CD + Docker + Version tags

---

## 🎯 v2.0 — Production Features

### 🔴 Phase 5 — Payment & Real-time (Priority: Tinggi)

| Task | Detail | Repo | Status |
|------|--------|------|--------|
| **Real Payment Gateway** | **Integrasi Midtrans/Xendit (QRIS, VA, E-Wallet)** | API | ✅ |
| **WebSocket orders** | **Live notify kasir via ActionCable / Socket.io** | API + Web | ✅ |
| **Kitchen display** | **Screen terpisah untuk dapur — auto-refresh order masuk** | Web | ✅ |
| **Auto bill print** | **Auto-print struk via Bluetooth/HTTP thermal printer** | API + Mobile | ✅ |

### 🟡 Phase 6 — Inventory & Management (Priority: Sedang)

| Task | Detail | Repo | Status |
|------|--------|------|--------|
| **Inventory / Stok** | **CRUD stok bahan baku, min-stock alert** | API | ✅ |
| **Auto stock deduction** | **Stok otomatis berkurang saat transaksi cafe** | API | ✅ |
| **Supplier management** | **Kelola supplier + history pembelian** | API | ✅ |
| **Shift management** | **Jadwal karyawan, clock-in/out, absensi** | API + Web | ✅ |

### 🟡 Phase 7 — Customer Experience (Priority: Sedang)

| Task | Detail | Repo | Status |
|------|--------|------|--------|
| **Customer self-order** | **QR code meja → order dari HP sendiri** | Mobile + API | ✅ |
| **Loyalty points** | **Poin per transaksi, redeem reward** | API | ✅ |
| **Order history** | **Riwayat transaksi customer (via login)** | API + Mobile | ✅ |
| **Push notifications** | **Notifikasi status pesanan ke customer** | Mobile | ✅ |

### 🟢 Phase 8 — Advanced Features (Priority: Rendah)

| Task | Detail | Repo | Status |
|------|--------|------|--------|
| **Multi-branch support** | **Satu akun bisa manage banyak cabang** | API | ✅ |
| **Tax invoice (PPN)** | **Generate faktur pajak otomatis** | API | ✅ |
| **Analytics dashboard** | **Grafik penjualan, peak hours, tren produk** | Web | ✅ |
| **Dark mode toggle** | **Biar user bisa ganti tema sendiri** | Web | ✅ |
| **Export laporan** | **Export CSV laporan transaksi** | Web | ✅ |

---

## 🧪 Phase 9 — Testing & Perbaikan

| Task | Detail | Repo | Status |
|------|--------|------|--------|
| **Load testing** | **k6 / artillery — simulate 100 concurrent users** | API | ✅ |
| **Security audit** | **Cek JWT, rate limiting, SQL injection** | API | ✅ |
| **Expo EAS build** | **Build APK/AAB biar bisa install langsung** | Mobile | ✅ |
| **Play Store submission** | **Persiapkan listing + screenshots** | Mobile | ✅ |
| **Error monitoring** | **Sentry / Rollbar integration** | All | ✅ |
| **Performance optimization** | **Bundle size, image comp, lazy loading** | All | ✅ |

---

## 🌿 Branch Strategy
```
main    → Production (stable)
develop → Development (fitur baru)
v1      → Archive v1.0.x
```

## ✅ Progress Summary — v2.0 (2026-08-02)

| Phase | Status | Selesai/Total |
|-------|--------|:---:|
| Phase 5 — Payment & Real-time | ✅ DONE | 4/4 |
| Phase 6 — Inventory & Management | ✅ DONE | 4/4 |
| Phase 7 — Customer Experience | ✅ DONE | 4/4 |
| Phase 8 — Advanced Features | ✅ DONE | 5/5 |
| Phase 9 — Testing & Perbaikan | ✅ DONE | 6/6 |
| **TOTAL** | **✅ 100%** | **23/23** |

> Semua fase v2.0 selesai! Project production-ready. 🚀

## 🔑 Credentials (Dev)
| Role | Email | Password |
|------|-------|----------|
| Admin | admin@lumina.local | admin123 |
| Kasir Billiard | kasir.billiard@lumina.local | kasir123 |
| Kasir Cafe | kasir.cafe@lumina.local | kasir123 |

**API:** http://localhost:3000/api/v1  
**Web:** http://localhost:3002  
**Mobile:** Expo Go / EAS Build  
**DB:** PostgreSQL @ localhost:5433 `lumina_cafe_billiard_dev`  
**Docker:** `docker compose up -d` (from api/)
