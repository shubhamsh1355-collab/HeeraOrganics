import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/data/mock/mock_data.dart';
import 'package:heera_organics/data/repositories/cart_repository.dart';
import 'package:heera_organics/data/repositories/order_repository.dart';

void main() {
  group('Cart Calculation and Purchase Flow Regression Tests', () {
    test('CartState initial state is empty with zero totals', () {
      const cart = CartState();
      expect(cart.items, isEmpty);
      expect(cart.totalItemCount, 0);
      expect(cart.subtotal, 0);
      expect(cart.packagingFee, 0);
      expect(cart.deliveryFee, 0);
      expect(cart.grandTotal, 0);
    });

    test('Cart copyWith properly clears appliedCoupon to null', () {
      const initial = CartState(appliedCoupon: 'HEERAFARM', discount: 20);
      expect(initial.appliedCoupon, 'HEERAFARM');

      // Clear coupon by passing appliedCoupon: null
      final cleared = initial.copyWith(appliedCoupon: null, discount: 0);
      expect(cleared.appliedCoupon, isNull);
      expect(cleared.discount, 0);
    });

    test(
      'Cart decrement behavior: reduces quantity by 1, removes only when 0',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(cartProvider.notifier);
        final milk = MockData.products.firstWhere((p) => p.id == 'prod_milk');
        final paneer = MockData.products.firstWhere(
          (p) => p.id == 'prod_paneer',
        );

        // Add milk twice and paneer once
        notifier.addItem(milk);
        notifier.addItem(milk);
        notifier.addItem(paneer);

        var cart = container.read(cartProvider);
        expect(cart.totalItemCount, 3);
        expect(cart.getQuantity(milk.id), 2);
        expect(cart.getQuantity(paneer.id), 1);

        // Decrement milk by 1 -> quantity becomes 1, line is retained
        notifier.decrementItem(milk.id);
        cart = container.read(cartProvider);
        expect(cart.getQuantity(milk.id), 1);
        expect(cart.getQuantity(paneer.id), 1);
        expect(cart.items.length, 2);

        // Decrement milk again -> quantity reaches 0, milk line is removed, paneer remains
        notifier.decrementItem(milk.id);
        cart = container.read(cartProvider);
        expect(cart.getQuantity(milk.id), 0);
        expect(cart.getQuantity(paneer.id), 1);
        expect(cart.items.length, 1);
        expect(cart.items.first.product.id, paneer.id);
      },
    );

    test('Product-pack selection: distinct pack options create separate line items with accurate pricing', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);
      final milk = MockData.products.firstWhere((p) => p.id == 'prod_milk');
      expect(milk.packOptions.length, greaterThanOrEqualTo(2));

      final pack500ml = milk.packOptions[0];
      final pack1L = milk.packOptions[1];

      // Add 500ml pack and 1L pack
      notifier.addItem(milk, pack: pack500ml);
      notifier.addItem(milk, pack: pack1L);

      final cart = container.read(cartProvider);
      expect(cart.items.length, 2);
      expect(cart.getItemQuantity(milk.id, pack: pack500ml), 1);
      expect(cart.getItemQuantity(milk.id, pack: pack1L), 1);

      final item1 = cart.items.firstWhere(
        (i) => i.selectedPack?.id == pack500ml.id,
      );
      final item2 = cart.items.firstWhere(
        (i) => i.selectedPack?.id == pack1L.id,
      );

      expect(item1.unitPrice, pack500ml.price);
      expect(item2.unitPrice, pack1L.price);
      expect(cart.subtotal, pack500ml.price + pack1L.price);

      // Decrementing pack500ml removes only that pack line
      notifier.decrementItem(milk.id, pack: pack500ml);
      final updatedCart = container.read(cartProvider);
      expect(updatedCart.items.length, 1);
      expect(updatedCart.items.first.selectedPack?.id, pack1L.id);
    });

    test('Shared cart-total calculation for subtotal, packaging fee, delivery fee, tip, coupon and grand total', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);
      final tomato = MockData.products.firstWhere((p) => p.id == 'prod_tomato');

      // Tomato price is 28, add 2 tomatoes -> subtotal = 56
      notifier.addItem(tomato);
      notifier.addItem(tomato);

      var cart = container.read(cartProvider);
      expect(cart.subtotal, 56);
      expect(cart.packagingFee, 15);
      expect(cart.deliveryFee, 15); // subtotal < 330
      expect(cart.tip, 20); // default tip
      expect(cart.couponDiscount, 20); // default coupon HEERAFARM
      // grandTotal = 56 + 15 + 15 + 20 - 20 = 86
      expect(cart.grandTotal, 86);

      // Change tip to 30
      notifier.setTip(30);
      cart = container.read(cartProvider);
      expect(cart.tip, 30);
      expect(cart.grandTotal, 56 + 15 + 15 + 30 - 20); // 96

      // Remove coupon
      notifier.removeCoupon();
      cart = container.read(cartProvider);
      expect(cart.appliedCoupon, isNull);
      expect(cart.couponDiscount, 0);
      expect(cart.grandTotal, 56 + 15 + 15 + 30 - 0); // 116

      // Apply FIRSTORGANIC coupon (₹50 discount)
      final applied = notifier.applyCoupon('FIRSTORGANIC');
      expect(applied, isTrue);
      cart = container.read(cartProvider);
      expect(cart.appliedCoupon, 'FIRSTORGANIC');
      expect(cart.couponDiscount, 50);
      expect(cart.grandTotal, 56 + 15 + 15 + 30 - 50); // 66

      // Invalid coupon returns false and does not alter existing coupon
      final invalidApplied = notifier.applyCoupon('INVALID99');
      expect(invalidApplied, isFalse);
      cart = container.read(cartProvider);
      expect(cart.appliedCoupon, 'FIRSTORGANIC');
    });

    test('Free delivery applies when subtotal reaches threshold (₹330)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(cartProvider.notifier);
      final ghee = MockData.products.firstWhere((p) => p.id == 'prod_ghee');

      notifier.addItem(ghee);
      final cart = container.read(cartProvider);

      expect(cart.subtotal, ghee.price);
      expect(cart.deliveryFee, 0); // >= 330
      expect(cart.packagingFee, 15);
      expect(
        cart.grandTotal,
        ghee.price + 15 + 0 + cart.tip - cart.couponDiscount,
      );
    });

    test('Selected delivery slot is preserved across cart actions and transferred to order creation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final cartNotifier = container.read(cartProvider.notifier);
      final orderNotifier = container.read(orderProvider.notifier);

      expect(MockData.deliverySlots.length, greaterThanOrEqualTo(2));
      final slot1 = MockData.deliverySlots[0];
      final slot2 = MockData.deliverySlots[1];

      // Initial slot is slot1
      expect(container.read(cartProvider).selectedDeliverySlot?.id, slot1.id);

      // Select slot2
      cartNotifier.setDeliverySlot(slot2);
      expect(container.read(cartProvider).selectedDeliverySlot?.id, slot2.id);

      // Adding/decrementing items preserves selected slot
      final tomato = MockData.products.firstWhere((p) => p.id == 'prod_tomato');
      cartNotifier.addItem(tomato);
      expect(container.read(cartProvider).selectedDeliverySlot?.id, slot2.id);

      final cartState = container.read(cartProvider);
      // Create order with the cart state amounts and slot
      final order = orderNotifier.createOrder(
        items: cartState.items,
        address: MockData.addresses.first,
        slot: cartState.selectedDeliverySlot!,
        subtotal: cartState.subtotal,
        deliveryFee: cartState.deliveryFee,
        packagingFee: cartState.packagingFee,
        discount: cartState.discount,
        tip: cartState.tip,
        total: cartState.grandTotal,
        paymentMethod: 'UPI',
      );

      // Verify created order has identical amounts and slot
      expect(order.slot.id, slot2.id);
      expect(order.subtotal, cartState.subtotal);
      expect(order.packagingFee, cartState.packagingFee);
      expect(order.deliveryFee, cartState.deliveryFee);
      expect(order.discount, cartState.discount);
      expect(order.tip, cartState.tip);
      expect(order.total, cartState.grandTotal);
    });
  });
}
