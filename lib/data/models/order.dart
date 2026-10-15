import 'cart_item.dart';
import 'delivery_address.dart';
import 'delivery_slot.dart';

enum OrderStatus {
  placed,
  confirmed,
  harvesting,
  packed,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final DateTime createdAt;
  final OrderStatus status;
  final List<CartItem> items;
  final DeliveryAddress address;
  final DeliverySlot slot;
  final num subtotal;
  final num packagingFee;
  final num deliveryFee;
  final num discount;
  final num tip;
  final num total;
  final String paymentMethod;
  final bool isPaid;

  const Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.address,
    required this.slot,
    required this.subtotal,
    this.packagingFee = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.tip = 0,
    required this.total,
    required this.paymentMethod,
    this.isPaid = true,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.harvesting:
        return 'Fresh Harvest in Progress';
      case OrderStatus.packed:
        return 'Packed & Quality Checked';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered to Doorstep';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
