import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/cart_item.dart';
import '../models/delivery_slot.dart';
import '../models/product.dart';

class CartState {
  static const Object _sentinel = Object();

  final List<CartItem> items;
  final String? appliedCoupon;
  final num discount;
  final num tip;
  final DeliverySlot? selectedDeliverySlot;
  final num freeDeliveryThreshold;
  final num standardDeliveryFee;
  final num packagingFeeAmount;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.discount = 0,
    this.tip = 0,
    this.selectedDeliverySlot,
    this.freeDeliveryThreshold = 330,
    this.standardDeliveryFee = 15,
    this.packagingFeeAmount = 15,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  num get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  num get packagingFee => items.isEmpty ? 0 : packagingFeeAmount;

  num get deliveryFee => (items.isEmpty || subtotal >= freeDeliveryThreshold)
      ? 0
      : standardDeliveryFee;

  num get couponDiscount => discount;

  num get grandTotal {
    if (items.isEmpty) return 0;
    final total = subtotal + packagingFee + deliveryFee + tip - couponDiscount;
    return total < 0 ? 0 : total;
  }

  int getQuantity(String productId) {
    return items
        .where((i) => i.product.id == productId)
        .fold(0, (sum, i) => sum + i.quantity);
  }

  int getItemQuantity(String productId, {PackOption? pack}) {
    if (pack == null) return getQuantity(productId);
    final item = items
        .where(
          (i) => i.product.id == productId && i.selectedPack?.id == pack.id,
        )
        .firstOrNull;
    return item?.quantity ?? 0;
  }

  CartState copyWith({
    List<CartItem>? items,
    Object? appliedCoupon = _sentinel,
    num? discount,
    num? tip,
    Object? selectedDeliverySlot = _sentinel,
    num? freeDeliveryThreshold,
    num? standardDeliveryFee,
    num? packagingFeeAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: identical(appliedCoupon, _sentinel)
          ? this.appliedCoupon
          : appliedCoupon as String?,
      discount: discount ?? this.discount,
      tip: tip ?? this.tip,
      selectedDeliverySlot: identical(selectedDeliverySlot, _sentinel)
          ? this.selectedDeliverySlot
          : selectedDeliverySlot as DeliverySlot?,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      standardDeliveryFee: standardDeliveryFee ?? this.standardDeliveryFee,
      packagingFeeAmount: packagingFeeAmount ?? this.packagingFeeAmount,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState(
      appliedCoupon: 'HEERAFARM',
      discount: 20,
      tip: 20,
      selectedDeliverySlot: MockData.deliverySlots.isNotEmpty
          ? MockData.deliverySlots[0]
          : null,
    );
  }

  void addItem(Product product, {PackOption? pack}) {
    final effectivePack =
        pack ??
        (product.packOptions.isNotEmpty ? product.packOptions.first : null);
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedPack?.id == effectivePack?.id,
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
          CartItem(product: product, selectedPack: effectivePack, quantity: 1),
        ],
      );
    }
  }

  void decrementItem(String productId, {PackOption? pack}) {
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == productId &&
          (pack == null || item.selectedPack?.id == pack.id),
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

  void removeItem(String productId, {PackOption? pack}) {
    if (pack == null) {
      state = state.copyWith(
        items: state.items.where((i) => i.product.id != productId).toList(),
      );
    } else {
      state = state.copyWith(
        items: state.items
            .where(
              (i) =>
                  !(i.product.id == productId && i.selectedPack?.id == pack.id),
            )
            .toList(),
      );
    }
  }

  void deleteItem(String productId, {PackOption? pack}) =>
      removeItem(productId, pack: pack);

  void clearCart() {
    state = CartState(selectedDeliverySlot: state.selectedDeliverySlot);
  }

  bool applyCoupon(String code) {
    final normalized = code.trim().toUpperCase();
    if (normalized == 'HEERAFARM') {
      state = state.copyWith(appliedCoupon: 'HEERAFARM', discount: 20);
      return true;
    } else if (normalized == 'FIRSTORGANIC') {
      state = state.copyWith(appliedCoupon: 'FIRSTORGANIC', discount: 50);
      return true;
    }
    return false;
  }

  void removeCoupon() {
    state = state.copyWith(appliedCoupon: null, discount: 0);
  }

  void setTip(num tipAmount) {
    state = state.copyWith(tip: tipAmount);
  }

  void setDeliverySlot(DeliverySlot slot) {
    state = state.copyWith(selectedDeliverySlot: slot);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
