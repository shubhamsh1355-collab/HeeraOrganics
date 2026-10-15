import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/data/repositories/order_repository.dart';

void main() {
  group('Seeded Orders Consistency Regression Tests', () {
    test('Seeded order HO-ORD-8921 has mathematically consistent item total and grand total', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final orders = container.read(orderProvider);
      final order = orders.firstWhere((o) => o.id == 'HO-ORD-8921');

      // Calculate items sum
      final itemsTotal = order.items.fold<num>(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );

      // In HO-ORD-8921:
      // Item 1: 2x Country Tomatoes @ 28 = 56
      // Item 2: 1x Banganapalli Mangoes @ 220 = 220
      // Sum = 276
      expect(itemsTotal, 276);
      expect(order.subtotal, 276);
      expect(order.packagingFee, 15);
      expect(order.deliveryFee, 0);
      expect(order.discount, 0);

      // Grand total = subtotal + packagingFee + deliveryFee + tip - discount
      final expectedTotal =
          order.subtotal +
          order.packagingFee +
          order.deliveryFee +
          order.tip -
          order.discount;
      expect(order.total, expectedTotal);
      expect(order.total, 291);
    });

    test('All seeded orders satisfy grand total mathematical identity', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final orders = container.read(orderProvider);

      for (final order in orders) {
        final itemsTotal = order.items.fold<num>(
          0,
          (sum, item) => sum + (item.unitPrice * item.quantity),
        );
        expect(
          order.subtotal,
          itemsTotal,
          reason: 'Order ${order.id} subtotal must match items sum',
        );

        final expectedTotal =
            (order.subtotal +
                    order.packagingFee +
                    order.deliveryFee +
                    order.tip -
                    order.discount)
                .clamp(0, double.infinity);
        expect(
          order.total,
          expectedTotal,
          reason: 'Order ${order.id} total must match sum of all components',
        );
      }
    });
  });
}
