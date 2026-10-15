import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final List<CartItem> items;
  final String? appliedCoupon;
  final num discount;
  final num tip;
  final num freeDeliveryThreshold;
  final num standardDeliveryFee;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.discount = 0,
    this.tip = 0,
    this.freeDeliveryThreshold = 299,
    this.standardDeliveryFee = 35,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  num get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  num get deliveryFee => (subtotal >= freeDeliveryThreshold || subtotal == 0)
      ? 0
      : standardDeliveryFee;

  num get grandTotal =>
      (subtotal - discount + deliveryFee + tip).clamp(0, double.infinity);

  int getQuantity(String productId) {
    final item = items.where((i) => i.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  CartState copyWith({
    List<CartItem>? items,
    String? appliedCoupon,
    num? discount,
    num? tip,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      discount: discount ?? this.discount,
      tip: tip ?? this.tip,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  void addItem(Product product, {PackOption? pack}) {
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id && item.selectedPack?.id == pack?.id,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(product: product, selectedPack: pack, quantity: 1),
        ],
      );
    }
  }

  void decrementItem(String productId) {
    final existingIndex = state.items.indexWhere(
      (i) => i.product.id == productId,
    );
    if (existingIndex < 0) return;

    final current = state.items[existingIndex];
    final updated = List<CartItem>.from(state.items);

    if (current.quantity > 1) {
      updated[existingIndex] = current.copyWith(quantity: current.quantity - 1);
      state = state.copyWith(items: updated);
    } else {
      updated.removeAt(existingIndex);
      state = state.copyWith(items: updated);
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((i) => i.product.id != productId).toList(),
    );
  }

  void clearCart() {
    state = const CartState();
  }

  void applyCoupon(String code) {
    if (code.toUpperCase() == 'FIRSTORGANIC') {
      state = state.copyWith(appliedCoupon: code.toUpperCase(), discount: 50);
    }
  }

  void removeCoupon() {
    state = state.copyWith(appliedCoupon: null, discount: 0);
  }

  void setTip(num tipAmount) {
    state = state.copyWith(tip: tipAmount);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
