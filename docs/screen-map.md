# Heera Organics — Screen Map & Inventory (24 Stitch Screens)

**Document ID:** HO-SM-001  
**Last Updated:** 2026-10-15  
**Total Screens:** 24  
**Branch:** `fix/cart-checkout-consistency`

This map tracks every approved Stitch screen reference, its visual source folder, planned Flutter route, feature module, and implementation status.

---

| # | Screen / Export Name | Planned Route | Feature Module | Main Responsibilities & Key Elements | Status |
|---|---|---|---|---|---|
| 1 | `splash_welcome_screen` | `/splash` | `onboarding` | Brand logo, hero banner, "Explore Fresh Catalogue", "Check Delivery Area", "Browse as Guest" | Completed |
| 2 | `phone_otp_login` | `/login` | `authentication` | Phone number field, 6-digit OTP boxes, resend timer, "Verify & Continue", terms & privacy links | Completed |
| 3 | `location_delivery_area` | `/location` | `delivery_area` | "Use Current Location", pincode lookup, locality list, confirmation CTA | Completed |
| 4 | `home_page` | `/home` | `home` | Delivery header, search bar, category shortcuts, hero carousel, curated sections, bottom nav | Completed |
| 5 | `search_discovery` | `/search` | `search` | Search field, trending & recent searches, popular quick-add items, category chips | Completed |
| 6 | `category_browsing_subcategories` | `/categories` | `categories` | Category sidebar/grid, subcategory chips, featured produce tiles, add-to-cart | Completed |
| 7 | `fresh_vegetables_product_listing` | `/products` | `product_listing` | Product grid/list toggle, category pills, filter & sort buttons, product cards, floating basket bar | Completed |
| 8 | `product_quick_view_filter_overlays` | `[overlay]` | `product_listing` | Modal bottom sheets: Quick product preview with pack options, filter drawer, sort modal | Completed |
| 9 | `product_details_desi_country_tomatoes` | `/product/:id` | `product_details` | Reusable PDP: 1:1 image gallery, dynamic pack selection chips, savings, farm details, decrement/add, clear Product Not Found state | Completed |
| 10 | `your_cart_basket` | `/cart` | `cart` | Cart item list with pack labels & unit prices, quantity stepper decrement by 1, coupon apply/remove, slot selection, tip UI, unified bill breakdown, proceed button | Completed |
| 11 | `checkout` | `/checkout` | `checkout` | Delivery address summary, carried delivery slot, simulated payment methods, unified bill calculation (subtotal, packaging, delivery, tip, coupon discount) | Completed |
| 12 | `order_confirmation_live_tracking` | `/order-confirmation` | `checkout` | Success badge, mock order reference, items breakdown, carried delivery slot & grand total, simulated tracking timeline, "Shop More" | Completed |
| 13 | `your_orders` | `/orders` | `orders` | Tabs (All, Active, Delivered, Subscriptions), order cards, tracking & invoice shortcuts, reorder action, mathematically consistent seeded orders | Completed |
| 14 | `order_details_status_tracking` | `/order/:id` | `orders` | Single order timeline, items list, destination address, packaging fee & tip in payment breakdown, PDF invoice mock, help CTA | Completed |
| 15 | `profile_account_overview` | `/profile` | `profile` | Customer summary, quick order action, addresses, preferences, referral link, support, sign out | Completed |
| 16 | `edit_profile_account_settings` | `/profile/edit` | `profile` | Editable name, email, phone, household size, delivery instructions, save/discard actions | Completed |
| 17 | `saved_addresses_location_management` | `/addresses` | `addresses` | Saved address list, default badge, edit/delete actions, "Add New Address", delivery notes | Completed |
| 18 | `saved_harvests_wishlist` | `/wishlist` | `wishlist` | Saved products list, group tabs, remove action, "Move to Basket", "Add All to Basket" | Completed |
| 19 | `refer_earn` | `/referral` | `referral` | Referral banner, invite code display, copy/share buttons, how it works, terms & rewards ledger | Completed |
| 20 | `help_support` | `/support` | `support` | Issue shortcuts, call/WhatsApp mock actions, order help, FAQs shortcut, contact info | Completed |
| 21 | `frequently_asked_questions_faqs` | `/faqs` | `support` | Topic filter chips, expandable accordion Q&A rows, ask question CTA | Completed |
| 22 | `ai_farm_chatbot_agronomist_support` | `/farm-assistant` | `farm_assistant` | Conversation bubbles, suggested prompts, text field, mock agronomist advice | Completed |
| 23 | `empty_unavailable_states` | `[reusable]` | `app_states` | Reusable empty cart, product not found, no search results, out of delivery zone, offline banner | Completed |
| 24 | `system_states_loaders` | `[reusable]` | `app_states` | Skeleton loaders, retry on network error, processing dialogs, permission denied sheets | Completed |
