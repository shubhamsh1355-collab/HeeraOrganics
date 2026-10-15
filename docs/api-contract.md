# Heera Organics — API Contract & Odoo Integration Boundary (Provisional)

**Document ID:** HO-API-001  
**Version:** 1.0 (Provisional)  
**Date:** 2026-10-15  

> **Note:** During the current Frontend Build Phase, all endpoints are served via local mock repositories. This document outlines the planned HTTP API surface for custom Odoo controllers when the backend integration phase begins.

---

## 1. Authentication & Session

- `POST /api/v1/auth/request-otp`: Request 6-digit OTP for phone number.
- `POST /api/v1/auth/verify-otp`: Verify code, returns JWT/session cookie and customer profile.
- `POST /api/v1/auth/guest-token`: Issues ephemeral guest browsing token.

---

## 2. Serviceability & Delivery

- `GET /api/v1/delivery/check-pincode?pincode=585102`: Validates service area, returns serviceable status, delivery slots, and fee tiers.
- `GET /api/v1/delivery/slots`: Returns available morning/evening delivery time slots.

---

## 3. Product Catalog & Categories

- `GET /api/v1/products/categories`: Returns hierarchical category list with icons and product counts.
- `GET /api/v1/products?category_id=...&search=...&sort=...&page=...`: Paginated product listing.
- `GET /api/v1/products/:id`: Detailed product spec, pack sizes, nutritional/farm attributes, and real-time inventory status.

---

## 4. Cart & Checkout

- `POST /api/v1/cart/quote`: Server-revalidates item availability, prices, applied coupons, delivery fees, and tax.
- `POST /api/v1/orders/create`: Validates slot, address, and creates pending order with Odoo order reference.
- `POST /api/v1/orders/:id/payment-verify`: Webhook/callback endpoint for payment gateway status.

---

## 5. Orders & Tracking

- `GET /api/v1/orders`: Customer's order history.
- `GET /api/v1/orders/:id`: Detailed status timeline, items, address, and invoice download link.
- `POST /api/v1/orders/:id/reorder`: Copies eligible in-stock items into active basket.
