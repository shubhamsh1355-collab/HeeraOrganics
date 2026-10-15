# Heera Organics — Open Questions & Asset Tracking

**Document ID:** HO-OQ-001  
**Last Updated:** 2026-10-15  
**Status:** Active  

This document tracks unresolved business questions, environmental limitations, and missing assets. Per the Master Project Brief, unconfirmed items are documented here rather than fabricated as production rules.

---

## 1. Visual Assets & Fonts

| Item | Status | Action / Fallback |
|---|---|---|
| **Literata & Source Serif 4 Font TTFs** | Not bundled in Stitch export ZIP | Loaded via `google_fonts` package and bundled in `assets/fonts/` for offline support. |
| **Product Imagery** | Stitch `code.html` references temporary Google AIDA preview URLs | High-quality, royalty-free organic farm photography matching the exact `data-alt` descriptions and 1:1 aspect ratio will be placed in `assets/images/products/` and `assets/images/banners/`. |
| **Material Symbols Outlined** | Uses standard Flutter `Icons` / Material Symbols | Map directly to Flutter `Icons.*` equivalents. |

---

## 2. Mock Mode Boundaries (Frontend Phase)

| Feature | Mock Implementation | Real Integration Notes (Future Odoo Phase) |
|---|---|---|
| **Phone OTP Login** | Local simulation; any 6-digit code or demo button logs in. | Real SMS/WhatsApp OTP provider will be configured in Odoo backend later. |
| **Location & Serviceability** | Simulates serviceable area (e.g., Kalaburagi localities) with manual selection & pincode check. | Real GPS / geocoding and Odoo-configured service zones will be connected later. |
| **Payment Gateways** | UI selection only (UPI, Cards, NetBanking, COD). "Place Order" generates demo order. | No payment SDK or live gateway called; webhooks & gateway keys handled via Odoo in later phase. |
| **Live Dispatch Tracking** | Simulated static status timeline (Order Placed -> Packed -> Out for Delivery -> Delivered). | No live GPS vehicle tracking; real status will be driven by Odoo delivery order state. |
| **AI Farm Assistant** | Predefined sample agronomist responses and suggested prompts. | Explicitly labeled as prototype; no live GenAI or agronomist service. |
| **Refer & Earn** | Local mock share sheet & demo referral code. | Real wallet/credits require backend accounting in Odoo. |

---

## 3. Platform & Build Tooling

| Target | Toolchain Status | Notes |
|---|---|---|
| **Android** | In progress (Windows development environment) | Standard APK/bundle builds to be verified once Android SDK is configured. |
| **iOS** | Not available on local Windows host | Requires macOS and Xcode for actual iOS build. Documented as a local environment limitation; all Dart/Flutter code is written to be 100% cross-platform compatible. |
