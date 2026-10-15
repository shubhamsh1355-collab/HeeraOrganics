import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/profile_repository.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI (Google Pay / PhonePe)';
  bool _isPlacingOrder = false;

  final List<String> _paymentMethods = [
    'UPI (Google Pay / PhonePe)',
    'Credit / Debit Card',
    'Net Banking (All Indian Banks)',
    'Pay on Delivery (Cash / QR)',
  ];

  void _placeOrder() {
    final cartState = ref.read(cartProvider);
    final profileState = ref.read(profileProvider);

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Your basket is empty!')));
      return;
    }

    final slot = cartState.selectedDeliverySlot ?? MockData.deliverySlots.first;

    setState(() => _isPlacingOrder = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      final order = ref
          .read(orderProvider.notifier)
          .createOrder(
            items: cartState.items,
            address: profileState.selectedAddress,
            slot: slot,
            subtotal: cartState.subtotal,
            deliveryFee: cartState.deliveryFee,
            packagingFee: cartState.packagingFee,
            discount: cartState.discount,
            tip: cartState.tip,
            total: cartState.grandTotal,
            paymentMethod: _selectedPaymentMethod,
          );

      // Clear basket after order creation
      ref.read(cartProvider.notifier).clearCart();

      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      context.go('/order-confirmation?orderId=${order.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final selectedSlot =
        cartState.selectedDeliverySlot ?? MockData.deliverySlots.first;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Checkout & Review', style: AppTypography.headlineSm()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice: Mock mode indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: AppRadii.radiusMd,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo Checkout: No actual payment will be charged in this prototype phase.',
                      style: AppTypography.labelSm(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Address Summary
            Text('Delivery Destination', style: AppTypography.labelLg()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
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
                          profileState.selectedAddress.title,
                          style: AppTypography.titleCard(),
                        ),
                        Text(
                          profileState.selectedAddress.fullAddress,
                          style: AppTypography.bodySm(),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/addresses'),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Delivery Slot
            Text('Scheduled Harvest Dispatch', style: AppTypography.labelLg()),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.primaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedSlot.fullLabel,
                          style: AppTypography.titleCard(),
                        ),
                        Text(
                          'Harvested at 5:00 AM from Sedam Cluster',
                          style: AppTypography.bodySm(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Options
            Text(
              'Payment Method (UI Simulation)',
              style: AppTypography.labelLg(),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: _paymentMethods.map((method) {
                  return RadioListTile<String>(
                    title: Text(method, style: AppTypography.bodyMd()),
                    value: method,
                    groupValue: _selectedPaymentMethod,
                    activeColor: AppColors.primaryContainer,
                    onChanged: (val) =>
                        setState(() => _selectedPaymentMethod = val!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Bill Summary
            Text('Order Total', style: AppTypography.labelLg()),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Subtotal',
                        style: AppTypography.bodyMd(color: AppColors.mutedText),
                      ),
                      Text(
                        CurrencyFormatter.format(cartState.subtotal),
                        style: AppTypography.bodyMd(),
                      ),
                    ],
                  ),
                  if (cartState.packagingFee > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Eco-Friendly Packaging',
                          style: AppTypography.bodyMd(
                            color: AppColors.mutedText,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(cartState.packagingFee),
                          style: AppTypography.bodyMd(),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery',
                        style: AppTypography.bodyMd(color: AppColors.mutedText),
                      ),
                      Text(
                        cartState.deliveryFee == 0
                            ? 'FREE'
                            : CurrencyFormatter.format(cartState.deliveryFee),
                        style: AppTypography.bodyMd(
                          color: cartState.deliveryFee == 0
                              ? AppColors.primaryContainer
                              : AppColors.deepText,
                        ),
                      ),
                    ],
                  ),
                  if (cartState.tip > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Partner Tip',
                          style: AppTypography.bodyMd(
                            color: AppColors.mutedText,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(cartState.tip),
                          style: AppTypography.bodyMd(),
                        ),
                      ],
                    ),
                  ],
                  if (cartState.discount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Savings',
                          style: AppTypography.bodyMd(
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        Text(
                          '- ${CurrencyFormatter.format(cartState.discount)}',
                          style: AppTypography.bodyMd(
                            color: AppColors.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payable Amount', style: AppTypography.titleCard()),
                      Text(
                        CurrencyFormatter.format(cartState.grandTotal),
                        style: AppTypography.price(fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            AppButton(
              text:
                  'Place Demo Order • ${CurrencyFormatter.format(cartState.grandTotal)}',
              isLoading: _isPlacingOrder,
              onPressed: _placeOrder,
              width: double.infinity,
              height: 52,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
