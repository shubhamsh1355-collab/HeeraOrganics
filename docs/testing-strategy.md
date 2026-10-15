# Heera Organics — Testing Strategy

**Document ID:** HO-TEST-001  
**Last Updated:** 2026-10-15  

---

## 1. Test Levels

1. **Unit Tests (`test/unit/`):**
   - Data models serialization/deserialization.
   - Price, discount, tax, and cart total calculation in `CartNotifier`.
   - Currency (`₹` / INR) and date/slot formatters.
   - Repository interface contracts and mock data validation.

2. **Widget Tests (`test/widget/`):**
   - Design system component rendering (`AppButton`, `ProductCard`, `QuantityStepper`, `CategoryChip`).
   - Theme styling verification (ensuring correct background `#FFF8F1`, text `#243126`, action `#234C36`).
   - Screen visual structure & interaction tests (tapping "Add", incrementing/decrementing stepper, expanding FAQs).

3. **Navigation & Flow Tests (`test/navigation/`):**
   - Splash -> Location -> Home flow.
   - Product Listing -> Product Details -> Cart -> Checkout -> Order Confirmation.
   - Tab switching in bottom navigation.

---

## 2. Execution Commands

```bash
# Analyze code for static errors and linting
flutter analyze

# Format code
dart format lib test

# Run all automated tests
flutter test

# Run tests with coverage
flutter test --coverage
```
