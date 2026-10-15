import 'product.dart';

class CartItem {
  final Product product;
  final PackOption? selectedPack;
  final int quantity;

  const CartItem({
    required this.product,
    this.selectedPack,
    required this.quantity,
  });

  num get unitPrice => selectedPack?.price ?? product.price;

  num get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    Product? product,
    PackOption? selectedPack,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedPack: selectedPack ?? this.selectedPack,
      quantity: quantity ?? this.quantity,
    );
  }
}
