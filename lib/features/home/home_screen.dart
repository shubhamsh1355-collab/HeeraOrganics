import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _activeHeroIndex = 0;
  final PageController _heroController = PageController();

  final List<Map<String, String>> _heroSlides = [
    {
      'title': 'Good Food Begins at the Farm.',
      'subtitle': 'Harvested at 5 AM • 100% Organic • Delivered with Care',
      'tag': 'Freshness • Responsible Sourcing',
      'cta': 'Shop Fresh Now',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
    },
    {
      'title': 'Naturally Grown, Honestly Delivered.',
      'subtitle':
          'Chemical-free soil harvests brought directly to Kalaburagi homes.',
      'tag': '100% Pesticide Free',
      'cta': 'Explore Produce',
      'imageUrl':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800',
    },
    {
      'title': 'Fresh Morning Harvest to Doorstep.',
      'subtitle':
          'Enjoy Desi Gir cow milk, farm paneer & heirloom pulses before 7 AM.',
      'tag': 'Morning Harvest Batch',
      'cta': 'Order Essentials',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800',
    },
  ];

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: const Icon(Icons.spa, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heera Organics',
                    style: AppTypography.titleCard(color: AppColors.deepText),
                  ),
                  InkWell(
                    onTap: () => context.push('/addresses'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deliver to ',
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ).copyWith(fontSize: 10),
                        ),
                        Flexible(
                          child: Text(
                            profileState.selectedAddress.locality,
                            style: AppTypography.labelSm(
                              color: AppColors.deepText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: AppColors.mutedText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.deepText,
                ),
                onPressed: () => context.push('/cart'),
              ),
              if (cartState.totalItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartState.totalItemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () => context.go('/search'),
                borderRadius: AppRadii.radiusMd,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: AppRadii.radiusMd,
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.mutedText,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search fresh vegetables, A2 milk, grains…',
                          style: AppTypography.bodyMd(
                            color: AppColors.mutedText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.mic,
                        color: AppColors.mutedText,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Category Shortcuts
            SizedBox(
              height: 88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: MockData.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCategoryShortcut(
                      icon: Icons.apps,
                      label: 'All',
                      bgColor: AppColors.primaryContainer,
                      iconColor: Colors.white,
                      onTap: () => context.go('/categories'),
                    );
                  }
                  final cat = MockData.categories[index - 1];
                  return _buildCategoryShortcut(
                    icon: Icons.eco,
                    label: cat.name,
                    bgColor: AppColors.surfaceContainerLow,
                    iconColor: AppColors.primaryContainer,
                    onTap: () => context.push('/products?categoryId=${cat.id}'),
                  );
                },
              ),
            ),

            // Hero Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _heroController,
                      onPageChanged: (i) =>
                          setState(() => _activeHeroIndex = i),
                      itemCount: _heroSlides.length,
                      itemBuilder: (context, index) {
                        final slide = _heroSlides[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: AppRadii.radiusLg,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: AppRadii.radiusLg,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  slide['imageUrl']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: AppColors.primary),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        AppColors.deepText.withValues(
                                          alpha: 0.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        slide['tag']!,
                                        style: AppTypography.labelSm(
                                          color: AppColors.secondaryContainer,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        slide['title']!,
                                        style: AppTypography.headlineSm(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        slide['subtitle']!,
                                        style: AppTypography.bodySm(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryContainer,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: AppRadii.radiusMd,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () =>
                                            context.push('/products'),
                                        child: Text(
                                          slide['cta']!,
                                          style: AppTypography.labelSm(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Indicator Dots
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          _heroSlides.length,
                          (i) => Container(
                            width: _activeHeroIndex == i ? 16 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: _activeHeroIndex == i
                                  ? AppColors.secondaryContainer
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: AppRadii.radiusPill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Value Propositions Grid / Pill Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(child: _buildPropItem(Icons.nature, '100% Organic')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPropItem(Icons.schedule, 'Harvested at Dawn'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPropItem(Icons.recycling, 'Glass Bottles'),
                  ),
                ],
              ),
            ),

            // Curated Section 1: Fresh Vegetables & Morning Harvest
            _buildSectionHeader('Morning Harvest Greens & Veggies', () {
              context.push('/products?categoryId=cat_veg');
            }),
            _buildProductRow(
              MockData.products
                  .where((p) => p.categoryId == 'cat_veg')
                  .toList(),
              cartState,
              cartNotifier,
              profileState,
              profileNotifier,
            ),

            // Curated Section 2: Farm Dairy & A2 Milk
            _buildSectionHeader('Farm Fresh A2 Dairy', () {
              context.push('/products?categoryId=cat_dairy');
            }),
            _buildProductRow(
              MockData.products
                  .where((p) => p.categoryId == 'cat_dairy')
                  .toList(),
              cartState,
              cartNotifier,
              profileState,
              profileNotifier,
            ),

            // Curated Section 3: Seasonal Fruits & Staples
            _buildSectionHeader('Seasonal Fruits & Cold-Pressed Oils', () {
              context.push('/products');
            }),
            _buildProductRow(
              MockData.products
                  .where(
                    (p) =>
                        p.categoryId == 'cat_fruits' ||
                        p.categoryId == 'cat_oils',
                  )
                  .toList(),
              cartState,
              cartNotifier,
              profileState,
              profileNotifier,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryShortcut({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radiusMd,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderSubtle, width: 1.0),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.labelSm(color: AppColors.deepText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryContainer),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: AppTypography.labelSm(color: AppColors.deepText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.titleCard(color: AppColors.deepText),
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  'See All',
                  style: AppTypography.labelMd(
                    color: AppColors.primaryContainer,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(
    List<dynamic> products,
    CartState cartState,
    CartNotifier cartNotifier,
    ProfileState profileState,
    ProfileNotifier profileNotifier,
  ) {
    return SizedBox(
      height: 255,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final qty = cartState.getQuantity(product.id);
          final isFav = profileState.wishlistProductIds.contains(product.id);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 165,
              child: ProductCard(
                id: product.id,
                name: product.name,
                packSize: product.defaultPackSize,
                price: product.price,
                originalPrice: product.originalPrice,
                imageUrl: product.imageUrl,
                badgeText: product.badgeText,
                quantity: qty,
                isFavorite: isFav,
                onTap: () => context.push('/product/${product.id}'),
                onIncrement: () => cartNotifier.addItem(product),
                onDecrement: () => cartNotifier.decrementItem(product.id),
                onToggleFavorite: () =>
                    profileNotifier.toggleWishlist(product.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
