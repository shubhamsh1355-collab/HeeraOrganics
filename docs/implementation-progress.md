# Heera Organics — Implementation Progress Tracker

**Document ID:** HO-PROG-001  
**Last Updated:** 2026-10-15  
**Target Repository:** `https://github.com/shubhamsh1355-collab/HeeraOrganics.git`  
**Current Feature Branch:** `fix/cart-checkout-consistency`

---

## Overall Implementation Status: Frontend Prototype Complete (24/24 Screens Implemented) — Mock-Driven Baseline; Production Integrations Pending

> [!IMPORTANT]
> **Production Readiness Status: NOT Production-Ready (Prototype / Mock-Driven Phase)**  
> While the mobile UI is 100% implemented according to the 24 Stitch design specifications with verified client-side state consistency, the application currently operates on simulated mock services (`MockData`, mock repositories, local in-memory Riverpod state). It cannot be deemed production-ready until enterprise backend integrations (Odoo ERP, live OTP authentication, production payment gateways, and GIS serviceability) are implemented and verified.

---

## Implementation Phase Breakdown

| Phase | Description | Status | Verification & Deliverables |
|---|---|---|---|
| **Phase 0** | Workspace & Toolchain Audit | **COMPLETED** | - Reference docs & Stitch pack extracted to `docs/reference/` and `design/reference/`<br>- Git repository initialized with remote `https://github.com/shubhamsh1355-collab/HeeraOrganics.git`<br>- Flutter SDK 3.47.7 & Dart 3.13.5 verified<br>- Initial documentation & `.gitignore` created. |
| **Phase 1** | Flutter Scaffold & Shared Design System | **COMPLETED** | - Flutter project scaffolded with Riverpod & GoRouter<br>- Design tokens: `app_colors.dart`, `app_typography.dart`, `app_radii.dart`, `app_spacing.dart`, `app_theme.dart`<br>- Core reusable widgets: `AppButton`, `ProductCard`, `QuantityStepper`, `CategoryChip`, `AppBottomNav`, `AppEmptyView`, `AppErrorView`. |
| **Phase 2** | App Entry, Auth & Location | **PROTOTYPE COMPLETE** *(Mock)* | - Screen #1: Splash / Welcome (`splash_welcome_screen.dart`)<br>- Screen #2: Phone OTP Login (`phone_otp_login_screen.dart` - simulated OTP flow)<br>- Screen #3: Location / Delivery Area (`location_delivery_area_screen.dart` - mock pincodes). |
| **Phase 3** | Shopping Discovery | **COMPLETED** | - Screen #4: Home (`home_screen.dart`) with hero carousel, flash sales, categories, reviews, farm trust<br>- Screen #5: Search & Discovery (`search_discovery_screen.dart`)<br>- Screen #6: Categories Grid (`categories_screen.dart`)<br>- Screen #7 & #8: Product Listing & Filter/Sort Sheets (`product_listing_screen.dart`)<br>- Screen #9: Product Details (`product_details_screen.dart`) with pack sizes, badges, harvesting info. |
| **Phase 4** | Cart & Checkout | **COMPLETED** | - Screen #10: Cart Basket (`cart_screen.dart`) with live total calculation, tip selector, coupons<br>- Screen #11: Checkout Review (`checkout_screen.dart`) with delivery slot & payment selection<br>- Screen #12: Order Confirmation (`order_confirmation_screen.dart`) with order ID & delivery route. |
| **Phase 5** | Orders & Account | **COMPLETED** | - Screen #13: Orders List (`orders_screen.dart`) with status chips & reorder<br>- Screen #14: Order Details (`order_details_screen.dart`) with tracking milestone stepper & Order Not Found handling<br>- Screen #15: Profile (`profile_screen.dart`) with stats & quick settings<br>- Screen #16: Edit Profile (`edit_profile_screen.dart`)<br>- Screen #17: Saved Addresses (`saved_addresses_screen.dart`)<br>- Screen #18: Wishlist (`wishlist_screen.dart`) with batch add-to-cart<br>- Screen #19: Refer & Earn (`refer_earn_screen.dart`) with referral code & rewards. |
| **Phase 6** | Help & System States | **COMPLETED** | - Screen #20: Help & Support (`help_support_screen.dart`) with direct call/WhatsApp/email triggers<br>- Screen #21: FAQs Screen (`faqs_screen.dart`) with search & categorized accordion panels<br>- Screen #22: Farm Assistant Chatbot (`farm_assistant_screen.dart`) with simulated conversational responses<br>- Screen #23 & #24: System Loading & Error States (`app_empty_view.dart`, `app_error_view.dart`). |
| **Phase 7** | Quality Assurance & Regression Hardening | **COMPLETED** | - **Cart Decrement Correction:** Minus button decrements by 1; removes only the targeted item line upon reaching 0 while preserving other cart lines.<br>- **Dynamic Pack Selection:** Products use real distinct `packOptions` with equality comparison; pack selection carried across PDP, cart, and checkout with accurate unit pricing.<br>- **Multi-Pack Product Listing Isolation:** Product cards in `product_listing_screen.dart` and `search_discovery_screen.dart` bind to their specific pack option (`product.defaultPackOption`); displayed count and decrement controls operate strictly on that pack line without altering other pack sizes in cart.<br>- **Single Shared Cart Calculation:** Unified calculation in `CartState` for subtotal, packaging fee (₹15), delivery fee (free >= ₹330 else ₹15), tip, coupon discount, and grand total. Cart, checkout, and created order display identical amounts.<br>- **Shared State Management:** Coupons, tips, and delivery slot selections stored in `CartNotifier`; `copyWith()` uses a sentinel to allow clearing coupons (`null`).<br>- **Delivery Slot Carrying:** Selected delivery slot is carried from cart to checkout to order confirmation and order tracking.<br>- **Product Not Found State:** Replaced silent fallback to tomatoes with a dedicated `AppEmptyView` ("Product Not Found") when given an invalid product ID.<br>- **Order Details Unknown ID Handling:** Replaced silent fallback to first order with dedicated `AppEmptyView` ("Order Not Found") when navigating to an unknown order ID.<br>- **Clean Analyzer Migration:** Removed project-wide `deprecated_member_use: ignore` from `analysis_options.yaml`; migrated `RadioListTile` widgets in sort sheet and checkout to Flutter 3.32+ `RadioGroup` widget with zero warnings.<br>- **Automated Test Suite:** 19/19 tests passing (`cart_calculator_test.dart`, `currency_formatter_test.dart`, `seeded_order_test.dart`, `product_details_test.dart`, `product_listing_pack_test.dart`, `order_details_test.dart`, `widget_test.dart`). |

---

## Backend & Production Readiness Gap Analysis

The frontend prototype is structurally complete, robust, and verified. However, before deploying to production, the following production backend integrations must be implemented:

1. **Enterprise ERP Sync (Odoo 17/18 Integration):**
   - Live synchronization of product catalog, categories, pricing, and pack variants via Odoo XML-RPC / REST API.
   - Real-time inventory reservation, warehouse stock availability, and cold-chain batch tracking.
   - Bi-directional sync of sales orders, customer delivery slots, delivery partner dispatch, and invoices.
2. **Production Authentication Service:**
   - Replace the client-side simulated OTP verification with a production SMS gateway (Twilio, MSG91, or Firebase Phone Auth).
   - Implement JWT / bearer token auth persistence, token refresh lifecycles, and backend user profile management.
3. **Pincode & Geolocation Serviceability:**
   - Integrate live address geocoding and GIS polygon boundaries to confirm cold-chain delivery serviceability dynamically rather than checking a static list of Kalaburagi pincodes.
4. **Live Payment Gateway (PG):**
   - Integrate Razorpay / Cashfree / Stripe SDK for live UPI intent, QR code payments, NetBanking, and credit/debit card tokenization.
   - Implement server-side payment signature verification and webhook listeners for asynchronous payment status updates.
5. **Real-time Order Tracking & Telemetry:**
   - Connect delivery milestones and dispatch statuses to live WebSocket / Server-Sent Events (SSE) from the delivery fleet backend.

---

## 24 Stitch Screen Mapping Summary

| # | Screen Description | Source Stitch Reference | Implementation File | Prototype Status |
|---|---|---|---|---|
| 1 | Splash / Welcome Screen | `01_splash_welcome` | `lib/features/onboarding/splash_welcome_screen.dart` | Completed |
| 2 | Phone OTP Login | `02_phone_otp_login` | `lib/features/authentication/phone_otp_login_screen.dart` | Completed (Mock OTP) |
| 3 | Location & Delivery Area | `03_location_delivery_area` | `lib/features/delivery_area/location_delivery_area_screen.dart` | Completed (Mock Pincodes) |
| 4 | Home Screen | `04_home_screen` | `lib/features/home/home_screen.dart` | Completed |
| 5 | Search & Discovery | `05_search_discovery` | `lib/features/search/search_discovery_screen.dart` | Completed |
| 6 | Category Browsing | `06_category_browsing` | `lib/features/categories/categories_screen.dart` | Completed |
| 7 | Product Listing (Grid/List) | `07_product_listing_grid_view` | `lib/features/product_listing/product_listing_screen.dart` | Completed |
| 8 | Filter & Sort Bottom Sheet | `08_filter_sort_bottom_sheet` | Built into `product_listing_screen.dart` | Completed |
| 9 | Product Details | `09_product_details` | `lib/features/product_details/product_details_screen.dart` | Completed |
| 10 | Cart / Basket | `10_cart_basket` | `lib/features/cart/cart_screen.dart` | Completed |
| 11 | Checkout Review | `11_checkout_review` | `lib/features/checkout/checkout_screen.dart` | Completed (Mock Payments) |
| 12 | Order Confirmation | `12_order_confirmation` | `lib/features/checkout/order_confirmation_screen.dart` | Completed |
| 13 | Order History | `13_order_history` | `lib/features/orders/orders_screen.dart` | Completed |
| 14 | Order Tracking / Details | `14_order_tracking_details` | `lib/features/orders/order_details_screen.dart` | Completed |
| 15 | Profile / Account | `15_profile_account` | `lib/features/profile/profile_screen.dart` | Completed |
| 16 | Edit Profile | `16_edit_profile` | `lib/features/profile/edit_profile_screen.dart` | Completed |
| 17 | Saved Addresses | `17_saved_addresses` | `lib/features/addresses/saved_addresses_screen.dart` | Completed |
| 18 | Wishlist | `18_wishlist` | `lib/features/wishlist/wishlist_screen.dart` | Completed |
| 19 | Refer & Earn | `19_refer_earn` | `lib/features/referral/refer_earn_screen.dart` | Completed |
| 20 | Help & Support Hub | `20_help_support_hub` | `lib/features/support/help_support_screen.dart` | Completed |
| 21 | FAQs Screen | `21_faqs` | `lib/features/support/faqs_screen.dart` | Completed |
| 22 | Farm Assistant AI Chatbot | `22_farm_assistant_chatbot` | `lib/features/farm_assistant/farm_assistant_screen.dart` | Completed |
| 23 | Empty States | `23_empty_states` | `lib/core/widgets/app_empty_view.dart` | Completed |
| 24 | Error & Network States | `24_error_network_states` | `lib/core/widgets/app_error_view.dart` | Completed |
