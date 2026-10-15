# Heera Organics 🌿

An organic, farm-fresh grocery shopping Flutter application built for Android & iOS. Designed with an artisanal warm aesthetic featuring hand-picked organic vegetables, farm-pressed oils, pure A2 dairy essentials, pulses, and spices.

Connected Repository: [https://github.com/shubhamsh1355-collab/HeeraOrganics.git](https://github.com/shubhamsh1355-collab/HeeraOrganics.git)

---

## 🎨 Design System & Aesthetic Foundation

Heera Organics follows a farm-fresh visual identity derived from Stitch reference screens:

| Token | Name | Hex Code | Visual Application |
|---|---|---|---|
| **Cream Surface** | Surface Ground | `#FFF8F1` | Warm canvas, screen backgrounds |
| **Forest Green** | Deep Primary | `#234C36` | Brand headings, primary action buttons, key elements |
| **Soft Green** | Fresh Accent | `#DBF5D1` | Badges, tags, positive highlights, subtle containers |
| **Harvest Yellow** | Warm Accent | `#EDE0A5` | Organic badges, discount tags, promo highlights |
| **Deep Forest Charcoal** | Primary Text | `#243126` | High-contrast readable typography |
| **Card Surface** | White Card | `#FFFFFF` | Product cards, elevated sheets, modals |

### Typography
- **Display & Headings:** `Literata` (Warm, serif editorial feel)
- **Body & Numerals:** `Source Serif 4` (High legibility, rupee pricing, item counts)

---

## 📱 Implemented Screens (All 24 Stitch References)

1. **Splash & Welcome** (`/splash`): Brand story, artisan arches, guest/login entry points.
2. **Phone OTP Authentication** (`/login`): Phone number input, 6-digit OTP code input, auto-mock verification.
3. **Location & Delivery Area** (`/location`): Gulbarga pincode and locality selection with active route validation.
4. **Home Screen** (`/home`): Hero slide carousel, quick category chips, flash organic sales, farm trust indicators, organic reviews.
5. **Search & Discovery** (`/search`): Real-time query matching, recent search chips, popular product suggestions.
6. **Categories Screen** (`/categories`): Visual grid of produce, spices, dairy, oils, and seasonal specialties.
7. **Product Listing** (`/products`): Grid & list view toggle, sort bottom sheet, price & category filter drawer.
8. **Product Details** (`/product/:id`): Pack size selection, nutritional notes, farm source, quantity stepper.
9. **Cart & Basket** (`/cart`): Live subtotal calculation, free delivery threshold indicator (₹299), tip selector, promo coupon (`FIRSTORGANIC`).
10. **Checkout Review** (`/checkout`): Saved address selection, morning/evening delivery slot selector, payment method options.
11. **Order Confirmation** (`/order-confirmation`): Order ID generation, delivery slot confirmation, tracking CTA.
12. **Orders List** (`/orders`): Active and past orders, status badges (`Placed`, `Packing`, `Out for Delivery`, `Delivered`).
13. **Order Details & Tracking** (`/order/:id`): Itemized invoice, milestone tracking stepper, delivery partner notes.
14. **Profile & Account** (`/profile`): User details, loyalty badge, quick menu to addresses, orders, FAQs, support.
15. **Edit Profile** (`/edit-profile`): Name, email, household size, preferred language update.
16. **Saved Addresses** (`/addresses`): Default address management, add new delivery address dialog.
17. **Wishlist** (`/wishlist`): Saved organic favorites with direct "Move to Basket" actions.
18. **Refer & Earn** (`/referral`): Referral code share (`HEERA50`), referral reward tracker.
19. **Help & Support Hub** (`/support`): Quick WhatsApp, phone dialer, and email support cards.
20. **FAQs Screen** (`/faqs`): Expandable accordion answers organized by Ordering, Quality, Delivery, and Payments.
21. **Farm Assistant AI Chat** (`/farm-assistant`): Conversational farm guide for seasonal recommendations and recipe tips.
22. **Reusable Empty States** (`AppEmptyView`): Illustrated zero-data indicators across search, cart, orders, wishlist.
23. **Reusable Error & Network Views** (`AppErrorView`): Offline state, retry trigger, and diagnostic messaging.
24. **Filter & Sort Sheets**: Modal bottom sheets with instant filter resets and dynamic counts.

---

## 🛠️ Architecture & State Management

- **Flutter Framework:** Flutter 3.47.7 / Dart 3.13.5
- **State Management:** Riverpod 3.x (`flutter_riverpod: ^3.4.3`) using modern `Notifier<T>` and `NotifierProvider<Notifier, T>`
- **Routing:** `go_router: ^18.1.0` with `StatefulShellRoute.indexedStack` persistent bottom navigation
- **Fonts:** `google_fonts: ^9.0.0`
- **Zero Mock Leaks:** Pure frontend mock layer (`lib/data/mock/mock_data.dart`) simulating Odoo and delivery backend schemas without connecting to live databases or OTP gateways.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed and added to `PATH` (e.g., `flutter --version`)
- Android Studio / VS Code with Flutter extension
- Android device or emulator (or iOS Simulator on macOS)

### Run Locally
```bash
# Clone the repository
git clone https://github.com/shubhamsh1355-collab/HeeraOrganics.git
cd HeeraOrganics

# Fetch dependencies
flutter pub get

# Run static analysis
flutter analyze --no-fatal-infos

# Run automated tests
flutter test

# Run application on connected device/emulator
flutter run
```

---

## 🧪 Testing Suite

Automated unit and widget tests are located in `test/`:
- `test/unit/cart_calculator_test.dart`: Subtotal, free delivery threshold, discount application, item counts.
- `test/unit/currency_formatter_test.dart`: Currency formatting (₹) and zero handling.
- `test/widget_test.dart`: Core widget rendering, theme application, and tap handler tests.

Run tests anytime with:
```bash
flutter test
```
