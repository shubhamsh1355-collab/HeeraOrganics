import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_button.dart';
import '../../data/repositories/order_repository.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);
    final order =
        orders.where((o) => o.id == orderId).firstOrNull ?? orders.firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Order Confirmation', style: AppTypography.headlineSm()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Success Icon
            Center(
              child: Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppColors.softGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryContainer,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Order Placed Successfully!',
              style: AppTypography.headlineLgMobile(color: AppColors.deepText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Order ID: ${order?.id ?? orderId}',
              style: AppTypography.labelMd(color: AppColors.primaryContainer),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for supporting organic farmers. Our harvesting cluster has received your order.',
              style: AppTypography.bodyMd(color: AppColors.mutedText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Simulated Tracking Timeline
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
                        'Estimated Delivery',
                        style: AppTypography.labelSm(
                          color: AppColors.mutedText,
                        ),
                      ),
                      Text(
                        order?.slot.fullLabel ?? 'Tomorrow Morning',
                        style: AppTypography.labelMd(color: AppColors.deepText),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildTimelineStep(
                    icon: Icons.receipt_long,
                    title: 'Order Confirmed',
                    subtitle: 'Sent to Sedam organic harvest center',
                    isCompleted: true,
                    isCurrent: false,
                  ),
                  _buildTimelineStep(
                    icon: Icons.agriculture,
                    title: 'Morning Harvest',
                    subtitle: 'Handpicked fresh at dawn from fields',
                    isCompleted: false,
                    isCurrent: true,
                  ),
                  _buildTimelineStep(
                    icon: Icons.inventory_2,
                    title: 'Eco Packing & Quality Check',
                    subtitle: 'Cleaned, weighed and bottled in glass',
                    isCompleted: false,
                    isCurrent: false,
                  ),
                  _buildTimelineStep(
                    icon: Icons.delivery_dining,
                    title: 'Doorstep Delivery',
                    subtitle:
                        order?.address.fullAddress ?? 'Sedam Road, Kalaburagi',
                    isCompleted: false,
                    isCurrent: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (order != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: AppRadii.radiusLg,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.items.length} items ordered',
                          style: AppTypography.titleCard(),
                        ),
                        Text(
                          'Paid via ${order.paymentMethod}',
                          style: AppTypography.bodySm(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      CurrencyFormatter.format(order.total),
                      style: AppTypography.price(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            AppButton(
              text: 'Shop More Fresh Harvests',
              onPressed: () => context.go('/home'),
              width: double.infinity,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryContainer,
                side: const BorderSide(color: AppColors.primaryContainer),
                shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => context.push('/orders'),
              child: const Text('View All Orders'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    bool isLast = false,
  }) {
    Color iconColor = isCompleted
        ? AppColors.primaryContainer
        : (isCurrent ? AppColors.primaryContainer : AppColors.mutedText);
    Color bgColor = isCompleted
        ? AppColors.softGreen
        : (isCurrent
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainerLow);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? AppColors.primaryContainer
                        : AppColors.borderSubtle,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLg(
                      color: isCurrent
                          ? AppColors.primaryContainer
                          : AppColors.deepText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
