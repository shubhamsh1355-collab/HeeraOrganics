import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  int _selectedSlotIndex = 0;
  int _selectedTip = 20;
  bool _couponApplied = true;
  final TextEditingController _couponController =
      TextEditingController(text: 'HEERAFARM');

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
        appBar: AppBar(
          title: Text('Your Basket', style: AppTypography.headlineSm()),
        ),
        body: AppEmptyView(
          icon: Icons.shopping_bag_outlined,
          title: 'Your Basket is Empty',
          message:
              'Fill your pantry with freshly harvested vegetables, cold-pressed oils, and A2 Gir cow milk.',
          actionText: 'Explore Produce',
          onActionPressed: () => context.go('/home'),
        ),
      );
    }

    final subtotal = cartState.subtotal;
    final packagingFee = 15;
    final deliveryFee = subtotal >= 330 ? 0 : 15;
    final couponDiscount = _couponApplied ? 20 : 0;
    final total = (subtotal + packagingFee + deliveryFee + _selectedTip - couponDiscount)
        .clamp(0, 999999);

    final progressRatio = (subtotal / 330.0).clamp(0.0, 1.0);
    final neededForFree = (330 - subtotal).clamp(0, 330);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Your Basket',
              style: AppTypography.headlineSm(
                color: AppColors.deepText,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 6),
            Text(
              '(${cartState.totalItemCount} items)',
              style: AppTypography.labelSm(
                color: AppColors.mutedText,
              ).copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => cartNotifier.clearCart(),
            icon: const Icon(
              Icons.delete_sweep,
              size: 16,
              color: AppColors.errorAlert,
            ),
            label: Text(
              'Clear',
              style: AppTypography.labelSm(
                color: AppColors.errorAlert,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Destination Pill Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
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
                            profileState.selectedAddress.locality,
                            style: AppTypography.labelMd(
                              color: AppColors.deepText,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            _selectedSlotIndex == 0
                                ? 'Slot: Today, 3:00 PM – 5:00 PM'
                                : 'Slot: Tomorrow, 6:30 AM – 8:30 AM',
                            style: AppTypography.labelSm(
                              color: AppColors.mutedText,
                            ).copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push('/addresses'),
                      child: Row(
                        children: [
                          Text(
                            'Change',
                            style: AppTypography.labelMd(
                              color: AppColors.primaryContainer,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.edit,
                            size: 14,
                            color: AppColors.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Progress Bar & Freshness Guarantee Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.softGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco,
                            size: 18,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Morning Harvest Free Delivery',
                                    style: AppTypography.titleCard(
                                      color: AppColors.deepText,
                                    ).copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                  Text(
                                    '₹$subtotal / ₹330',
                                    style: AppTypography.labelMd(
                                      color: AppColors.primaryContainer,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              if (neededForFree > 0)
                                Text(
                                  'Add ₹$neededForFree more to unlock free direct farm dispatch!',
                                  style: AppTypography.bodySm(
                                    color: AppColors.mutedText,
                                  ).copyWith(fontSize: 11),
                                )
                              else
                                Text(
                                  'Free direct farm dispatch unlocked!',
                                  style: AppTypography.bodySm(
                                    color: AppColors.primaryContainer,
                                  ).copyWith(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Progress Track
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 7,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: AppColors.primaryContainer,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Direct from Kalaburagi farms • Harvested today',
                                style: AppTypography.labelSm(
                                  color: AppColors.deepText,
                                ).copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                          Text(
                            '4 hrs ago',
                            style: AppTypography.labelSm(
                              color: AppColors.mutedText,
                            ).copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Basket Items List
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fresh Harvest Items',
                    style: AppTypography.titleCard(
                      color: AppColors.deepText,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Freshness Guaranteed 100%',
                    style: AppTypography.labelSm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: cartState.items.map((cartItem) {
                  final p = cartItem.product;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: Image.network(
                              p.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      style: AppTypography.titleCard(
                                        color: AppColors.deepText,
                                      ).copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => cartNotifier.deleteItem(p.id),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                p.defaultPackSize,
                                style: AppTypography.labelSm(
                                  color: AppColors.mutedText,
                                ).copyWith(fontSize: 11),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.softGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  p.farmOrigin,
                                  style: AppTypography.labelSm(
                                    color: AppColors.primaryContainer,
                                  ).copyWith(fontSize: 9, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(p.price),
                                    style: AppTypography.headlineSm(
                                      color: AppColors.primaryContainer,
                                    ).copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                                  ),
                                  QuantityStepper(
                                    quantity: cartItem.quantity,
                                    onIncrement: () => cartNotifier.addItem(p),
                                    onDecrement: () => cartNotifier.removeItem(p.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // 4. Cross-sell Carousel: "Before You Checkout"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Before You Checkout',
                        style: AppTypography.titleCard(
                          color: AppColors.deepText,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Frequently paired with fresh vegetables',
                        style: AppTypography.labelSm(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                  Text(
                    'Fresh Add-ons',
                    style: AppTypography.labelSm(
                      color: AppColors.primaryContainer,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 172,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCrossSellCard(
                    context,
                    name: 'Tender Coriander',
                    pack: 'Bunch • 100 g',
                    price: 18,
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuD660gpbLZQ2-LZXsjoPAIRKqn7AabpJmZs4erDgWmhe29CVN1RqWs7OIXlgWkqyid-g5zTnZnETYyA62N-Nc_JfMuJVpQbxAA5fMfp7Ui5VQMWdeqnSpyhX5iPKt4pwMWXWWkEozF6W8-NnV5KYiNbifIN3lCvhfOvjFpBYux6uk8l214y2CjS-ek9mVKG9AShYRp4SJfH5nhCNlseyyXGmAaLkav6ljjDSq7lYxbJ0rQInYVBqRpF',
                    onAdd: () {
                      final prod = MockData.products.firstWhere(
                        (p) => p.id == 'prod_coriander',
                      );
                      cartNotifier.addItem(prod);
                    },
                  ),
                  _buildCrossSellCard(
                    context,
                    name: 'Green Chillies',
                    pack: 'Organic • 100 g',
                    price: 15,
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDjCX-ub-zp8vapz2unHfoNTxIj3aLQF45CbXF4r564Qd6zmDUMG8rLwQIBn75yhtXW30ctIQvecTWd5fLb_zm90f0syXVQsXzKo4yNhVGkw9tK5pasIlJpYfJIGGa1wUxOrYpHeh4tpmmc3qAUEMeWHglsdMm6H_umI1B1tBRLbY6EKR8Zopf0HsWkwWPwOPXM2ob2YCjiSd3hfip1vc7ctPv25izWxAjYzvTnyxpypMRYRE5Z1AwY',
                    onAdd: () {
                      final prod = MockData.products.firstWhere(
                        (p) => p.id == 'prod_chilli',
                      );
                      cartNotifier.addItem(prod);
                    },
                  ),
                  _buildCrossSellCard(
                    context,
                    name: 'Country Ginger',
                    pack: 'Aromatic • 100 g',
                    price: 20,
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAiXOiX-zaiC6wtDKaOTw6F6Tkuknl_pDYoExsgM773X8bmzvU5ac4lLYAoaZbLbGgPVBw_POxNToYQc3_V8o8DGe52CFJNO8UOGyLaz0UxKBCUvUrTPjvqKajaBZz_8B6UpfmZ0Lth_by51ThLNrt2VDdbc5CAylsVEfc_jMn4ifFfGmdaHehUWM2Jy7dUrbvXaR41pq6rgM6TTANvQ6_1SZvBTnBqs0D2VuxjNo378d-m1Ajtytys',
                    onAdd: () {
                      final prod = MockData.products.firstWhere(
                        (p) => p.id == 'prod_ginger',
                      );
                      cartNotifier.addItem(prod);
                    },
                  ),
                ],
              ),
            ),

            // 5. Choose Delivery Slot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          size: 18,
                          color: AppColors.primaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Choose Delivery Slot',
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Slot 1
                    GestureDetector(
                      onTap: () => setState(() => _selectedSlotIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedSlotIndex == 0
                              ? AppColors.softGreen
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedSlotIndex == 0
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: _selectedSlotIndex == 0
                                  ? AppColors.primaryContainer
                                  : AppColors.mutedText,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today, 3:00 PM – 5:00 PM',
                                    style: AppTypography.labelMd(
                                      color: AppColors.deepText,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Sunrise Batch • Reaching in ~2 hrs',
                                    style: AppTypography.labelSm(
                                      color: AppColors.primaryContainer,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Slot 2
                    GestureDetector(
                      onTap: () => setState(() => _selectedSlotIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedSlotIndex == 1
                              ? AppColors.softGreen
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedSlotIndex == 1
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: _selectedSlotIndex == 1
                                  ? AppColors.primaryContainer
                                  : AppColors.mutedText,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tomorrow, 6:30 AM – 8:30 AM',
                                    style: AppTypography.labelMd(
                                      color: AppColors.deepText,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Dawn Harvest • Straight from farm gate',
                                    style: AppTypography.labelSm(
                                      color: AppColors.mutedText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'FREE',
                              style: AppTypography.labelSm(
                                color: AppColors.primaryContainer,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Instructions
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.doorbell,
                            size: 16,
                            color: AppColors.mutedText,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    'Instructions: e.g. Ring bell & leave in basket',
                                hintStyle: AppTypography.bodySm(
                                  color: AppColors.mutedText,
                                ).copyWith(fontSize: 11),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. Coupons & Offers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.loyalty,
                              size: 18,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Coupons & Offers',
                              style: AppTypography.titleCard(
                                color: AppColors.deepText,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          '2 Available',
                          style: AppTypography.labelSm(
                            color: AppColors.primaryContainer,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_couponApplied)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.task_alt,
                              size: 18,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HEERAFARM Applied',
                                    style: AppTypography.labelMd(
                                      color: AppColors.primaryContainer,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '₹20 saved on organic staples & dairy',
                                    style: AppTypography.labelSm(
                                      color: AppColors.deepText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _couponApplied = false),
                              child: Text(
                                'Remove',
                                style: AppTypography.labelSm(
                                  color: AppColors.errorAlert,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _couponController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: 'Enter coupon code',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => setState(() => _couponApplied = true),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // 7. Delivery Partner Tip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Farm Hub Delivery Partner Tip',
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '100% to driver',
                          style: AppTypography.labelSm(color: AppColors.mutedText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Support our local delivery champions navigating village routes.',
                      style: AppTypography.bodySm(color: AppColors.mutedText)
                          .copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [10, 20, 30].map((tip) {
                        final isSelected = _selectedTip == tip;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTip = tip),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.softGreen
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '₹$tip',
                                    style: AppTypography.labelMd(
                                      color: isSelected
                                          ? AppColors.primaryContainer
                                          : AppColors.deepText,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  if (tip == 20) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.favorite,
                                      size: 13,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // 8. Bill Details Breakdown Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bill Details',
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Taxes Included',
                          style: AppTypography.labelSm(
                            color: AppColors.primaryContainer,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildBillRow('Item Subtotal (${cartState.totalItemCount} items)', '₹$subtotal'),
                    _buildBillRow('Eco-Friendly Brown Bag Packaging', '₹$packagingFee'),
                    _buildBillRow(
                      'Delivery Fee (Kalaburagi Zone)',
                      deliveryFee == 0 ? 'FREE' : '₹$deliveryFee',
                    ),
                    _buildBillRow('Delivery Partner Tip', '₹$_selectedTip'),
                    if (_couponApplied)
                      _buildBillRow(
                        'Coupon HEERAFARM',
                        '- ₹20',
                        color: AppColors.primaryContainer,
                        isBold: true,
                      ),
                    const Divider(height: 16, color: AppColors.borderSubtle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Pay',
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹$total',
                              style: AppTypography.headlineSm(
                                color: AppColors.primaryContainer,
                              ).copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Saved ₹${couponDiscount + (deliveryFee == 0 ? 15 : 0)} on this order',
                              style: AppTypography.labelSm(
                                color: AppColors.mutedText,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 14,
                            color: AppColors.mutedText,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Cancellation Policy: Free cancellation up until produce packs and leaves the Sedam farm dispatch hub.',
                              style: AppTypography.bodySm(
                                color: AppColors.mutedText,
                              ).copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '₹$total',
                        style: AppTypography.headlineLgMobile(
                          color: AppColors.primaryContainer,
                        ).copyWith(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹${total + 29}',
                        style: AppTypography.labelSm(
                          color: AppColors.mutedText,
                        ).copyWith(decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                  Text(
                    'Home: Sedam Road',
                    style: AppTypography.labelSm(
                      color: AppColors.deepText,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () => context.push('/checkout'),
                child: Row(
                  children: [
                    Text(
                      'Proceed to Pay',
                      style: AppTypography.labelLg(
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrossSellCard(
    BuildContext context, {
    required String name,
    required String pack,
    required int price,
    required String imageUrl,
    required VoidCallback onAdd,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 72,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: AppTypography.titleCard(
              color: AppColors.deepText,
            ).copyWith(fontWeight: FontWeight.w700, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            pack,
            style: AppTypography.labelSm(color: AppColors.mutedText).copyWith(
              fontSize: 9,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹$price',
                style: AppTypography.headlineSm(
                  color: AppColors.primaryContainer,
                ).copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        size: 11,
                        color: AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Add',
                        style: AppTypography.labelSm(
                          color: AppColors.primaryContainer,
                        ).copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySm(
              color: color ?? AppColors.mutedText,
            ).copyWith(fontSize: 11),
          ),
          Text(
            value,
            style: AppTypography.bodySm(
              color: color ?? AppColors.deepText,
            ).copyWith(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
