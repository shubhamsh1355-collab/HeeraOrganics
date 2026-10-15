import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/data/mock/mock_data.dart';
import 'package:heera_organics/data/repositories/cart_repository.dart';

void main() {
  group('Cart Calculation Logic Tests', () {
    test('cart initial state is empty with zero totals', () {
      final cart = CartState();
      expect(cart.items, isEmpty);
      expect(cart.totalItemCount, 0);
      expect(cart.subtotal, 0);
      expect(cart.grandTotal, 0);
    });

    test('adding items calculates subtotal and standard delivery fee', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final tomato = MockData.products.first;

      container.read(cartProvider.notifier).addItem(tomato);
      final cart = container.read(cartProvider);

      expect(cart.totalItemCount, 1);
      expect(cart.subtotal, tomato.price);
      expect(cart.deliveryFee, 35); // below ₹299 threshold
      expect(cart.grandTotal, tomato.price + 35);
    });

    test('delivery fee is waived when subtotal reaches freeDeliveryThreshold (₹299)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ghee = MockData.products.firstWhere(
        (p) => p.id == 'prod_ghee',
      );

      container.read(cartProvider.notifier).addItem(ghee);
      final cart = container.read(cartProvider);

      expect(cart.subtotal, ghee.price);
      expect(cart.deliveryFee, 0);
      expect(cart.grandTotal, ghee.price);
    });

    test('coupon code FIRSTORGANIC applies ₹50 discount', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ghee = MockData.products.firstWhere(
        (p) => p.id == 'prod_ghee',
      );

      container.read(cartProvider.notifier).addItem(ghee);
      container.read(cartProvider.notifier).applyCoupon('FIRSTORGANIC');
      final cart = container.read(cartProvider);

      expect(cart.discount, 50);
      expect(cart.grandTotal, ghee.price - 50);
    });
  });
}
