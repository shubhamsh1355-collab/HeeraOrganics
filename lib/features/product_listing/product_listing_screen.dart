import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/profile_repository.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const ProductListingScreen({super.key, this.initialCategoryId});

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  late String _selectedCategoryId;
  bool _isGridView = true;
  String _selectedSort = 'Popularity';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId ?? 'all';
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort Produce By', style: AppTypography.titleCard()),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: _selectedSort,
                onChanged: (val) {
                  setState(() => _selectedSort = val!);
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      [
                        'Popularity',
                        'Price: Low to High',
                        'Price: High to Low',
                        'Fresh Harvest First',
                      ].map((option) {
                        return RadioListTile<String>(
                          title: Text(option, style: AppTypography.bodyMd()),
                          value: option,
                          activeColor: AppColors.primaryContainer,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Harvests', style: AppTypography.titleCard()),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Reset',
                      style: AppTypography.labelMd(color: AppColors.mutedText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Dietary & Certification', style: AppTypography.labelLg()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  CategoryChip(
                    label: '100% Organic',
                    isSelected: true,
                    onTap: () {},
                  ),
                  CategoryChip(
                    label: 'Cold-Chained Dairy',
                    isSelected: false,
                    onTap: () {},
                  ),
                  CategoryChip(
                    label: 'Unpolished',
                    isSelected: false,
                    onTap: () {},
                  ),
                  CategoryChip(
                    label: 'Stone Ground',
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);

    List<Product> products = MockData.products;
    if (_selectedCategoryId != 'all') {
      products = products
          .where((p) => p.categoryId == _selectedCategoryId)
          .toList();
    }

    if (_selectedSort == 'Price: Low to High') {
      products = [...products]..sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price: High to Low') {
      products = [...products]..sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Fresh Produce', style: AppTypography.headlineSm()),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_outlined : Icons.grid_view_outlined,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Category Filter Pills
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CategoryChip(
                      label: 'All Harvests',
                      isSelected: _selectedCategoryId == 'all',
                      onTap: () => setState(() => _selectedCategoryId = 'all'),
                    ),
                    const SizedBox(width: 8),
                    ...MockData.categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryChip(
                          label: cat.name,
                          isSelected: _selectedCategoryId == cat.id,
                          onTap: () =>
                              setState(() => _selectedCategoryId = cat.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Filter & Sort Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.deepText,
                          side: const BorderSide(color: AppColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusPill,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: _showSortSheet,
                        icon: const Icon(Icons.sort, size: 16),
                        label: Text(
                          _selectedSort,
                          style: AppTypography.labelSm(
                            color: AppColors.deepText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.deepText,
                          side: const BorderSide(color: AppColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.radiusPill,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: _showFilterSheet,
                        icon: const Icon(Icons.tune, size: 16),
                        label: Text(
                          'Filters',
                          style: AppTypography.labelSm(
                            color: AppColors.deepText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Products Grid / List
              Expanded(
                child: _isGridView
                    ? GridView.builder(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: cartState.totalItemCount > 0 ? 80 : 20,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final targetPack = product.defaultPackOption;
                          return ProductCard(
                            id: product.id,
                            name: product.name,
                            packSize: targetPack.label,
                            price: targetPack.price,
                            originalPrice:
                                targetPack.originalPrice ??
                                product.originalPrice,
                            imageUrl: product.imageUrl,
                            badgeText: product.badgeText,
                            quantity: cartState.getItemQuantity(
                              product.id,
                              pack: targetPack,
                            ),
                            isFavorite: profileState.wishlistProductIds
                                .contains(product.id),
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
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: cartState.totalItemCount > 0 ? 80 : 20,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final targetPack = product.defaultPackOption;
                          final qty = cartState.getItemQuantity(
                            product.id,
                            pack: targetPack,
                          );
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.whiteSurface,
                              borderRadius: AppRadii.radiusLg,
                              border: Border.all(
                                color: AppColors.borderSubtle,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: AppRadii.radiusMd,
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        targetPack.label,
                                        style: AppTypography.labelSm(
                                          color: AppColors.mutedText,
                                        ),
                                      ),
                                      Text(
                                        product.name,
                                        style: AppTypography.titleCard(
                                          color: AppColors.deepText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        CurrencyFormatter.format(
                                          targetPack.price,
                                        ),
                                        style: AppTypography.price(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                QuantityStepper(
                                  quantity: qty,
                                  onIncrement: () => cartNotifier.addItem(
                                    product,
                                    pack: targetPack,
                                  ),
                                  onDecrement: () => cartNotifier.decrementItem(
                                    product.id,
                                    pack: targetPack,
                                  ),
                                  compact: true,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // Floating View Basket Bar
          if (cartState.totalItemCount > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: InkWell(
                onTap: () => context.push('/cart'),
                borderRadius: AppRadii.radiusMd,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadii.radiusMd,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${cartState.totalItemCount} ITEMS',
                            style: AppTypography.labelSm(
                              color: AppColors.softGreen,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(cartState.grandTotal),
                            style: AppTypography.price(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'View Basket',
                            style: AppTypography.labelLg(color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
