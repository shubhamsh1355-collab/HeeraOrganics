import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  PackOption? _selectedPack;

  @override
  Widget build(BuildContext context) {
    final product =
        MockData.products.where((p) => p.id == widget.productId).firstOrNull ??
        MockData.products.first;

    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);

    final currentPack =
        _selectedPack ??
        (product.packOptions.isNotEmpty ? product.packOptions.first : null);
    final effectivePrice = currentPack?.price ?? product.price;
    final qty = cartState.getQuantity(product.id);
    final isFav = profileState.wishlistProductIds.contains(product.id);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(product.name, style: AppTypography.titleCard()),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.errorAlert : AppColors.deepText,
            ),
            onPressed: () => profileNotifier.toggleWishlist(product.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.deepText),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sharing ${product.name} link')),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1:1 Large Image Presentation
            AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                color: AppColors.whiteSurface,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.eco,
                      size: 60,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: AppRadii.radiusPill,
                        ),
                        child: Text(
                          product.badgeText ?? '100% Organic',
                          style: AppTypography.labelSm(
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: AppRadii.radiusPill,
                        ),
                        child: Text(
                          'Pesticide Free',
                          style: AppTypography.labelSm(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    product.name,
                    style: AppTypography.headlineLgMobile(
                      color: AppColors.deepText,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price & Strikethrough
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(effectivePrice),
                        style: AppTypography.price(fontSize: 24),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          CurrencyFormatter.format(product.originalPrice!),
                          style: AppTypography.bodyMd(
                            color: AppColors.mutedText,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pack Selection (if options exist)
                  if (product.packOptions.isNotEmpty) ...[
                    Text(
                      'Select Pack Size',
                      style: AppTypography.labelLg(color: AppColors.deepText),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: product.packOptions.map((pack) {
                        final isSelected = currentPack?.id == pack.id;
                        return ChoiceChip(
                          label: Text(
                            '${pack.label} - ${CurrencyFormatter.format(pack.price)}',
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.softGreen,
                          backgroundColor: AppColors.whiteSurface,
                          labelStyle: AppTypography.labelMd(
                            color: isSelected
                                ? AppColors.primaryContainer
                                : AppColors.deepText,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusPill,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryContainer
                                  : AppColors.borderSubtle,
                            ),
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedPack = pack),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Farm Origin Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: AppRadii.radiusMd,
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.place,
                          'Origin',
                          product.farmOrigin,
                        ),
                        const Divider(height: 16),
                        _buildInfoRow(
                          Icons.agriculture,
                          'Harvesting',
                          product.harvestingMethod,
                        ),
                        const Divider(height: 16),
                        _buildInfoRow(
                          Icons.kitchen,
                          'Storage',
                          product.storageTip,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('About This Harvest', style: AppTypography.titleCard()),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTypography.bodyMd(color: AppColors.deepText),
                  ),
                  const SizedBox(height: 80), // spacing for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.whiteSurface,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1.0),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: AppTypography.labelSm(color: AppColors.mutedText),
                  ),
                  Text(
                    CurrencyFormatter.format(
                      effectivePrice * (qty > 0 ? qty : 1),
                    ),
                    style: AppTypography.price(fontSize: 20),
                  ),
                ],
              ),
              if (qty > 0)
                QuantityStepper(
                  quantity: qty,
                  height: 44,
                  onIncrement: () =>
                      cartNotifier.addItem(product, pack: currentPack),
                  onDecrement: () => cartNotifier.decrementItem(product.id),
                )
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () =>
                      cartNotifier.addItem(product, pack: currentPack),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text('Add to Basket'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryContainer),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSm(color: AppColors.mutedText),
              ),
              Text(
                value,
                style: AppTypography.bodySm(color: AppColors.deepText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
