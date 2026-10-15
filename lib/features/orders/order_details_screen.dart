import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);
    final order = orders.where((o) => o.id == orderId).firstOrNull;
    final cartNotifier = ref.read(cartProvider.notifier);

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text('Order Not Found', style: AppTypography.headlineSm()),
        ),
        body: AppEmptyView(
          icon: Icons.receipt_long_outlined,
          title: 'Order Not Found',
          message:
              'The requested order "$orderId" could not be found or does not exist.',
          actionText: 'View All Orders',
          onActionPressed: () => context.go('/orders'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(order.id, style: AppTypography.titleCard()),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push('/support'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: AppTypography.labelMd(
                          color: AppColors.mutedText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: AppRadii.radiusPill,
                        ),
                        child: Text(
                          order.statusLabel,
                          style: AppTypography.labelSm(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Slot: ${order.slot.fullLabel}',
                    style: AppTypography.titleCard(),
                  ),
                  Text(
                    'Ordered on ${DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt)}',
                    style: AppTypography.bodySm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Destination
            Text('Delivery Address', style: AppTypography.labelLg()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primaryContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.address.title,
                          style: AppTypography.labelLg(),
                        ),
                        Text(
                          order.address.fullAddress,
                          style: AppTypography.bodySm(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items List
            Text(
              'Harvest Items (${order.items.length})',
              style: AppTypography.labelLg(),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadii.radiusMd,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              item.product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.surfaceContainerLow,
                                    child: const Icon(
                                      Icons.eco,
                                      size: 24,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: AppTypography.titleCard(),
                              ),
                              Text(
                                '${item.quantity} x ${item.selectedPack?.label ?? item.product.defaultPackSize}',
                                style: AppTypography.bodySm(
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(item.totalPrice),
                          style: AppTypography.price(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Payment & Bill Summary
            Text('Payment Breakdown', style: AppTypography.labelLg()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildRow(
                    'Item Subtotal',
                    CurrencyFormatter.format(order.subtotal),
                  ),
                  if (order.packagingFee > 0) ...[
                    const SizedBox(height: 6),
                    _buildRow(
                      'Eco-Friendly Packaging',
                      CurrencyFormatter.format(order.packagingFee),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _buildRow(
                    'Delivery Partner Fee',
                    order.deliveryFee == 0
                        ? 'FREE'
                        : CurrencyFormatter.format(order.deliveryFee),
                  ),
                  if (order.tip > 0) ...[
                    const SizedBox(height: 6),
                    _buildRow(
                      'Delivery Partner Tip',
                      CurrencyFormatter.format(order.tip),
                    ),
                  ],
                  if (order.discount > 0) ...[
                    const SizedBox(height: 6),
                    _buildRow(
                      'Discount',
                      '- ${CurrencyFormatter.format(order.discount)}',
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Paid', style: AppTypography.titleCard()),
                      Text(
                        CurrencyFormatter.format(order.total),
                        style: AppTypography.price(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Mode',
                        style: AppTypography.labelSm(
                          color: AppColors.mutedText,
                        ),
                      ),
                      Text(
                        order.paymentMethod,
                        style: AppTypography.labelSm(color: AppColors.deepText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reorder and Invoice actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.deepText,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tax Invoice download started (demo PDF).',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Invoice'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      for (final item in order.items) {
                        cartNotifier.addItem(
                          item.product,
                          pack: item.selectedPack,
                        );
                      }
                      context.push('/cart');
                    },
                    child: const Text('Reorder All'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMd(color: AppColors.mutedText)),
        Text(value, style: AppTypography.bodyMd(color: AppColors.deepText)),
      ],
    );
  }
}
