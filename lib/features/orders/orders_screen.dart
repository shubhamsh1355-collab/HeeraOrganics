import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../data/models/order.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Your Orders',
          style: AppTypography.headlineSm(color: AppColors.deepText),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryContainer,
          unselectedLabelColor: AppColors.mutedText,
          indicatorColor: AppColors.primaryContainer,
          indicatorWeight: 3,
          labelStyle: AppTypography.labelMd(),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Delivered'),
            Tab(text: 'Subscriptions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(orders, cartNotifier),
          _buildOrderList(
            orders
                .where(
                  (o) =>
                      o.status != OrderStatus.delivered &&
                      o.status != OrderStatus.cancelled,
                )
                .toList(),
            cartNotifier,
            emptyMessage: 'You have no active orders in transit.',
          ),
          _buildOrderList(
            orders.where((o) => o.status == OrderStatus.delivered).toList(),
            cartNotifier,
            emptyMessage: 'No past deliveries recorded yet.',
          ),
          AppEmptyView(
            icon: Icons.repeat,
            title: 'No Recurring Subscriptions',
            message: 'Set up daily morning milk or weekly harvest vegetable deliveries for automatic doorstep drop-offs.',
            actionText: 'Explore Daily Dairy',
            onActionPressed: () =>
                context.push('/products?categoryId=cat_dairy'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
    List<Order> orders,
    CartNotifier cartNotifier, {
    String? emptyMessage,
  }) {
    if (orders.isEmpty) {
      return AppEmptyView(
        icon: Icons.receipt_long_outlined,
        title: 'No Orders Found',
        message: emptyMessage ?? 'You have not placed any orders yet. Discover fresh harvest produce to get started.',
        actionText: 'Start Shopping',
        onActionPressed: () => context.go('/home'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteSurface,
            borderRadius: AppRadii.radiusLg,
            border: Border.all(color: AppColors.borderSubtle, width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Reference & Status Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: AppTypography.labelLg(
                            color: AppColors.deepText,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a')
                              .format(order.createdAt),
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: order.status == OrderStatus.delivered
                            ? AppColors.softGreen
                            : AppColors.secondaryContainer,
                        borderRadius: AppRadii.radiusPill,
                      ),
                      child: Text(
                        order.statusLabel,
                        style: AppTypography.labelSm(
                          color: order.status == OrderStatus.delivered
                              ? AppColors.primary
                              : AppColors.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Items Summary
                ...order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.product.name} (${item.selectedPack?.label ?? item.product.defaultPackSize})',
                            style: AppTypography.bodyMd(
                              color: AppColors.deepText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(item.totalPrice),
                          style: AppTypography.labelMd(
                            color: AppColors.deepText,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 20),

                // Total and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTypography.labelMd(color: AppColors.mutedText),
                    ),
                    Text(
                      CurrencyFormatter.format(order.total),
                      style: AppTypography.price(
                        color: AppColors.primaryContainer,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryContainer,
                          side: const BorderSide(
                            color: AppColors.primaryContainer,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusMd,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () => context.push('/order/${order.id}'),
                        child: const Text('View Timeline'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusMd,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                        ),
                        onPressed: () {
                          for (final item in order.items) {
                            cartNotifier.addItem(
                              item.product,
                              pack: item.selectedPack,
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Items added back to your cart!'),
                              backgroundColor: AppColors.primaryContainer,
                            ),
                          );
                          context.push('/cart');
                        },
                        child: const Text('Reorder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
