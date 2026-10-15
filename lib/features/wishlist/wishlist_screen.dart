import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);

    final savedProducts = MockData.products
        .where((p) => profileState.wishlistProductIds.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Saved Harvests (${savedProducts.length})',
          style: AppTypography.headlineSm(),
        ),
        actions: [
          if (savedProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                for (final p in savedProducts) {
                  cartNotifier.addItem(p);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All saved harvests added to your basket!'),
                    backgroundColor: AppColors.primaryContainer,
                  ),
                );
                context.push('/cart');
              },
              child: Text(
                'Add All to Basket',
                style: AppTypography.labelMd(color: AppColors.primaryContainer),
              ),
            ),
        ],
      ),
      body: savedProducts.isEmpty
          ? AppEmptyView(
              icon: Icons.favorite_border,
              title: 'No Saved Harvests',
              message: 'Tap the heart on fresh vegetables, A2 milk, or cold-pressed oils to save them for your next shopping run.',
              actionText: 'Explore Produce',
              onActionPressed: () => context.go('/home'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedProducts.length,
              itemBuilder: (context, index) {
                final product = savedProducts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: AppRadii.radiusLg,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadii.radiusMd,
                        child: Image.network(
                          product.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTypography.titleCard(),
                            ),
                            Text(
                              product.defaultPackSize,
                              style: AppTypography.bodySm(
                                color: AppColors.mutedText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(product.price),
                              style: AppTypography.price(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: AppColors.errorAlert,
                        ),
                        onPressed: () =>
                            profileNotifier.toggleWishlist(product.id),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusMd,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          cartNotifier.addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} moved to basket!'),
                            ),
                          );
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
