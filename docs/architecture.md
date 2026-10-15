# Heera Organics — Frontend Architecture Document

**Document ID:** HO-ARCH-001  
**Version:** 1.0  
**Date:** 2026-10-15  
**Platform:** Flutter + Dart (Android & iOS)  

---

## 1. Architectural Principles

1. **Feature-First Organization:** Code is structured by business capability (`home`, `cart`, `checkout`, `orders`, `profile`), with shared infrastructure isolated in `core/` and data abstractions in `data/`.
2. **Strict Layer Separation:**
   - **Presentation Layer (UI):** Stateless and Consumer widgets reacting to Riverpod providers. No direct database or API logic in widgets.
   - **Domain / State Layer:** StateNotifier / Notifier providers holding pure, immutable UI state and business logic.
   - **Data Layer:** Typed models and Repository interfaces (`ProductRepository`, `CartRepository`, `OrderRepository`, etc.).
3. **Single Source of Truth for State:**
   - Derived values (e.g. cart badge count, subtotal, discount, delivery fee, grand total) are calculated centrally in `CartNotifier`. No widget re-calculates or hard-codes totals.
4. **Mock Isolation for Future Odoo Swapping:**
   - All repositories expose standard Dart abstract interfaces.
   - Currently, `MockProductRepository`, `MockCartRepository`, etc. satisfy these contracts with in-memory state.
   - When Odoo Community HTTP controllers are built in a future phase, Odoo-backed implementations will be injected into Riverpod providers without modifying screen widgets.

---

## 2. Directory Responsibilities

- `lib/core/theme/`: Definitive design tokens matching `03_STITCH_DESIGN_SYSTEM.txt` (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadii`, `AppTheme`).
- `lib/core/routing/`: `go_router` setup with named routes and deep-link parameters.
- `lib/core/widgets/`: Reusable primitives (`AppButton`, `ProductCard`, `QuantityStepper`, `CategoryChip`, `AppBottomNav`, `AppEmptyView`, `AppErrorView`).
- `lib/data/models/`: Strongly typed Dart data models.
- `lib/data/mock/`: Realistic sample data for groceries, categories, addresses, orders, and FAQs.
- `lib/data/repositories/`: Abstract repository contracts and mock implementations.
- `lib/features/`: Feature-specific screens and local widgets.
