import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_empty_view.dart';
import '../../core/widgets/product_card.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class SearchDiscoveryScreen extends ConsumerStatefulWidget {
  const SearchDiscoveryScreen({super.key});

  @override
  ConsumerState<SearchDiscoveryScreen> createState() =>
      _SearchDiscoveryScreenState();
}

class _SearchDiscoveryScreenState extends ConsumerState<SearchDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<String> _trending = [
    'Desi Tomatoes',
    'A2 Cow Milk',
    'Fresh Palak',
    'Unpolished Toor Dal',
    'Wood Pressed Oil',
    'Bilona Ghee',
  ];

  final List<String> _recent = ['Tender Okra', 'Gir Cow Milk'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);

    List<Product> searchResults = [];
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      searchResults = MockData.products
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 16,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.whiteSurface,
            borderRadius: AppRadii.radiusMd,
            border: Border.all(color: AppColors.borderSubtle, width: 1.0),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: false,
            style: AppTypography.bodyMd(color: AppColors.deepText),
            decoration: InputDecoration(
              hintText: 'Search farm produce, A2 dairy…',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.mutedText,
                size: 20,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: AppColors.mutedText,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : const Icon(Icons.mic, color: AppColors.mutedText, size: 20),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (val) => setState(() => _query = val),
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trending Searches
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 18,
                        color: AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Trending on Heera Organics',
                        style: AppTypography.labelLg(color: AppColors.deepText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _trending.map((term) {
                      return ActionChip(
                        label: Text(
                          term,
                          style: AppTypography.labelSm(
                            color: AppColors.deepText,
                          ),
                        ),
                        backgroundColor: AppColors.whiteSurface,
                        side: const BorderSide(color: AppColors.borderSubtle),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.radiusPill,
                        ),
                        onPressed: () {
                          _searchController.text = term;
                          setState(() => _query = term);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Recent Searches
                  if (_recent.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.history,
                              size: 18,
                              color: AppColors.mutedText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Recent Searches',
                              style: AppTypography.labelLg(
                                color: AppColors.deepText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: _recent.map((term) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.search,
                            size: 18,
                            color: AppColors.mutedText,
                          ),
                          title: Text(
                            term,
                            style: AppTypography.bodyMd(
                              color: AppColors.deepText,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.north_west,
                            size: 16,
                            color: AppColors.mutedText,
                          ),
                          onTap: () {
                            _searchController.text = term;
                            setState(() => _query = term);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Popular Picks
                  Text(
                    'Frequently Purchased from Farms',
                    style: AppTypography.titleCard(color: AppColors.deepText),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final product = MockData.products[index];
                      final targetPack = product.defaultPackOption;
                      return ProductCard(
                        id: product.id,
                        name: product.name,
                        packSize: targetPack.label,
                        price: targetPack.price,
                        originalPrice:
                            targetPack.originalPrice ?? product.originalPrice,
                        imageUrl: product.imageUrl,
                        badgeText: product.badgeText,
                        quantity: cartState.getItemQuantity(
                          product.id,
                          pack: targetPack,
                        ),
                        isFavorite: profileState.wishlistProductIds.contains(
                          product.id,
                        ),
                        onTap: () => context.push('/product/${product.id}'),
                        onIncrement: () =>
                            cartNotifier.addItem(product, pack: targetPack),
                        onDecrement: () => cartNotifier.decrementItem(
                          product.id,
                          pack: targetPack,
                        ),
                        onToggleFavorite: () =>
                            profileNotifier.toggleWishlist(product.id),
                      );
                    },
                  ),
                ],
              ),
            )
          : searchResults.isEmpty
          ? AppEmptyView(
              icon: Icons.search_off,
              title: 'No produce matches "$_query"',
              message: 'Try checking your spelling or search by general category like tomatoes, milk or dal.',
              actionText: 'Clear Search',
              onActionPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final product = searchResults[index];
                final targetPack = product.defaultPackOption;
                return ProductCard(
                  id: product.id,
                  name: product.name,
                  packSize: targetPack.label,
                  price: targetPack.price,
                  originalPrice:
                      targetPack.originalPrice ?? product.originalPrice,
                  imageUrl: product.imageUrl,
                  badgeText: product.badgeText,
                  quantity: cartState.getItemQuantity(
                    product.id,
                    pack: targetPack,
                  ),
                  isFavorite: profileState.wishlistProductIds.contains(
                    product.id,
                  ),
                  onTap: () => context.push('/product/${product.id}'),
                  onIncrement: () =>
                      cartNotifier.addItem(product, pack: targetPack),
                  onDecrement: () =>
                      cartNotifier.decrementItem(product.id, pack: targetPack),
                  onToggleFavorite: () =>
                      profileNotifier.toggleWishlist(product.id),
                );
              },
            ),
    );
  }
}
