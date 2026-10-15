import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/cart_item.dart';
import '../models/delivery_address.dart';
import '../models/delivery_slot.dart';
import '../models/order.dart';

class OrderNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    final item1 = CartItem(
      product: MockData.products[0],
      selectedPack: MockData.products[0].effectivePackOptions.first,
      quantity: 2,
    );
    final item2 = CartItem(
      product: MockData.products[4],
      selectedPack: MockData.products[4].effectivePackOptions.first,
      quantity: 1,
    );

    final subtotal =
        item1.totalPrice + item2.totalPrice; // 2 * 28 + 1 * 220 = 276
    const packagingFee = 15;
    const deliveryFee = 0; // Free delivery (promotional morning harvest)
    const discount = 0;
    const tip = 0;
    final total = subtotal + packagingFee + deliveryFee + tip - discount; // 291

    return [
      Order(
        id: 'HO-ORD-8921',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        items: [item1, item2],
        address: MockData.addresses[0],
        slot: MockData.deliverySlots[1],
        subtotal: subtotal,
        packagingFee: packagingFee,
        deliveryFee: deliveryFee,
        discount: discount,
        tip: tip,
        total: total,
        paymentMethod: 'UPI (Google Pay)',
      ),
    ];
  }

  Order createOrder({
    required List<CartItem> items,
    required DeliveryAddress address,
    required DeliverySlot slot,
    required num subtotal,
    required num packagingFee,
    required num deliveryFee,
    required num discount,
    required num tip,
    required num total,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'HO-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      createdAt: DateTime.now(),
      status: OrderStatus.placed,
      items: items,
      address: address,
      slot: slot,
      subtotal: subtotal,
      packagingFee: packagingFee,
      deliveryFee: deliveryFee,
      discount: discount,
      tip: tip,
      total: total,
      paymentMethod: paymentMethod,
    );

    state = [order, ...state];
    return order;
  }

  Order? getOrderById(String id) {
    return state.where((o) => o.id == id).firstOrNull;
  }
}

final orderProvider = NotifierProvider<OrderNotifier, List<Order>>(
  OrderNotifier.new,
);
