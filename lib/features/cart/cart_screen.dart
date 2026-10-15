import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/delivery_slot.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  DeliverySlot _selectedSlot =
      MockData.deliverySlots[1]; // default tomorrow morning

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartState.items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(title: const Text('Your Basket')),
        body: AppEmptyView(
          icon: Icons.shopping_bag_outlined,
          title: 'Your Basket is Empty',
          message: 'Fill your pantry with freshly harvested vegetables, cold-pressed oils, and A2 Gir cow milk.',
          actionText: 'Explore Produce',
          onActionPressed: () => context.go('/home'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Your Basket (${cartState.totalItemCount} items)',
          style: AppTypography.titleCard(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartNotifier.clearCart();
            },
            child: Text(
              'Clear',
              style: AppTypography.labelMd(color: AppColors.errorAlert),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Header Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivering To',
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ),
                        ),
                        Text(
                          profileState.selectedAddress.fullAddress,
                          style: AppTypography.bodySm(
                            color: AppColors.deepText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/addresses'),
                    child: Text(
                      'Change',
                      style: AppTypography.labelSm(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Item Rows
            Text(
              'Produce & Essentials',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartState.items.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: AppColors.borderSubtle),
                itemBuilder: (context, index) {
                  final item = cartState.items[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadii.radiusMd,
                          child: Image.network(
                            item.product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: AppTypography.titleCard(
                                  color: AppColors.deepText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.selectedPack?.label ??
                                    item.product.defaultPackSize,
                                style: AppTypography.labelSm(
                                  color: AppColors.mutedText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(item.totalPrice),
                                style: AppTypography.price(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        QuantityStepper(
                          quantity: item.quantity,
                          compact: true,
                          onIncrement: () => cartNotifier.addItem(
                            item.product,
                            pack: item.selectedPack,
                          ),
                          onDecrement: () =>
                              cartNotifier.decrementItem(item.product.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Slot Selection
            Text(
              'Choose Delivery Harvest Slot',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: Column(
                children: MockData.deliverySlots
                    .where((s) => s.isAvailable)
                    .map((slot) {
                      return RadioListTile<DeliverySlot>(
                        title: Text(
                          slot.fullLabel,
                          style: AppTypography.bodyMd(),
                        ),
                        subtitle: Text(
                          slot.isMorningHarvest
                              ? 'Harvested at dawn'
                              : 'Evening fresh dispatch',
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ),
                        ),
                        value: slot,
                        groupValue: _selectedSlot,
                        activeColor: AppColors.primaryContainer,
                        onChanged: (val) =>
                            setState(() => _selectedSlot = val!),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Coupon Code Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.primaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: const InputDecoration(
                        hintText: 'Enter FIRSTORGANIC',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_couponController.text.trim().isNotEmpty) {
                        cartNotifier.applyCoupon(_couponController.text.trim());
                      }
                    },
                    child: Text(
                      'Apply',
                      style: AppTypography.labelMd(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (cartState.appliedCoupon != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.primaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Coupon ${cartState.appliedCoupon} applied! ₹50 saved.',
                      style: AppTypography.labelSm(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Bill Summary
            Text(
              'Bill Summary',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildBillRow(
                    'Item Total',
                    CurrencyFormatter.format(cartState.subtotal),
                  ),
                  const SizedBox(height: 8),
                  _buildBillRow(
                    'Delivery Partner Fee',
                    cartState.deliveryFee == 0
                        ? 'FREE'
                        : CurrencyFormatter.format(cartState.deliveryFee),
                    isGreen: cartState.deliveryFee == 0,
                  ),
                  if (cartState.discount > 0) ...[
                    const SizedBox(height: 8),
                    _buildBillRow(
                      'Coupon Discount',
                      '- ${CurrencyFormatter.format(cartState.discount)}',
                      isGreen: true,
                    ),
                  ],
                  if (cartState.tip > 0) ...[
                    const SizedBox(height: 8),
                    _buildBillRow(
                      'Delivery Partner Tip',
                      CurrencyFormatter.format(cartState.tip),
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grand Total',
                        style: AppTypography.titleCard(
                          color: AppColors.deepText,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(cartState.grandTotal),
                        style: AppTypography.price(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              text: 'Proceed to Checkout',
              onPressed: () {
                context.push('/checkout');
              },
              width: double.infinity,
              height: 52,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMd(color: AppColors.mutedText)),
        Text(
          value,
          style: isGreen
              ? AppTypography.labelMd(color: AppColors.primaryContainer)
              : AppTypography.bodyMd(color: AppColors.deepText),
        ),
      ],
    );
  }
}
