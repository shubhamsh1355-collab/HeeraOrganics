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

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _selectedPhotoIndex = 0;
  int _selectedPackIndex = 0;

  final List<String> _galleryImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBMMyPQjAySqSBEU7s9P6dqj79ssWxg6GI1cjEDOb0aAxToz7Vo_qF0ZkRFfpDcBwDxFXQNQj6rU1WkjnQi4f77qOpw_SJU9OESYMHnFyBdNl1FJ_6t7bw-M8MPGA-v0qLodGPqNGsjS5dgw_jrbvTMtFSbYQEFFmQV0vADvSKkdhLEtbC4JM_bfhWUumPR8j9ryVMMhUGvwMRkiitaFdMxklpu-6jPCbaoIFtUmxyjg9wGC157rKR8',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAlVZudWFvy2K2W0Qx-rUdfRnmZ2vUcU6vZZ5xenRYwTc2u6OS2YkeCwR7n5RDbp4q9EBBEeVpa3TOqudLrzL6FaXQdzMVP9gghP52Hv0W2D3sEFcVv7GlNBXaDtWJ5qBKB1kA4QmAkhVbOMGnHQLefjug0QeloPt3rkps3ELrcKOoKK5Qy4-AsG7wWmoNLNzwkayWP7rEzcSBn0P5R8M6D_N-hzP8ko-cm0og8xSxCctyTrW-QXT2J',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBTSXSesCDaNhuLtVrBCEYhlSVCJ4lsmCyOPiOwEP7-RJQ4f77ZFVPCd0hXfqZlSsvDOE8Vm8wKKIQjw5324wJETgh_Ff0ryEEMrbLB9Q0hoJ864a_783v1Dwp26_n_S_uunZj404LMSxEJIShbV09IbDvFwT_1HtATc8wE9V8KXm2ugEZs_naM9FAroph2-u-Z_T9VdD77fJUe6sRdrX6Y9tGWJ_9Rk9fzfwsY4DEL8Fp1-aNMfAKi',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB7y15OYZodxPtXrd5WUQDRtucDayg_searGsa-WmewIiuur3yjwVHBx8nhC69wEuMJWoOBmSGOyRGdW6x_ME5S2E2wGXrlzA4Xsy3CkTIPsaspeviBo3W6xBYPZ7dJdnW_4n1ottbUiL6iUzqMHmEKUxwfFcINuKRPhiFSp2-lscNlbfxlsSO0Wvou2-V0xu-oD63uRzvotcvCLARyIEJf3kUsJSnxPL-st0Se80kJg6seiNy9FLWB',
  ];

  @override
  Widget build(BuildContext context) {
    final product = MockData.products
        .where((p) => p.id == widget.productId)
        .firstOrNull;

    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text('Product Not Found', style: AppTypography.headlineSm()),
        ),
        body: AppEmptyView(
          icon: Icons.search_off,
          title: 'Product Not Found',
          message: 'The requested harvest item is currently unavailable or does not exist.',
          actionText: 'Back to Fresh Produce',
          onActionPressed: () => context.go('/home'),
        ),
      );
    }

    final cartState = ref.watch(cartProvider);
    final profileState = ref.watch(profileProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);

    final packOptions = product.effectivePackOptions;
    final selectedPackIndex = _selectedPackIndex < packOptions.length
        ? _selectedPackIndex
        : 0;
    final selectedPack = packOptions.isNotEmpty
        ? packOptions[selectedPackIndex]
        : null;

    final effectivePrice = selectedPack?.price ?? product.price;
    final originalPrice = selectedPack?.originalPrice ?? product.originalPrice;
    final qty = cartState.getItemQuantity(product.id, pack: selectedPack);
    final isFav = profileState.wishlistProductIds.contains(product.id);

    final galleryImages = [
      product.imageUrl,
      ..._galleryImages.where((img) => img != product.imageUrl),
    ];
    final activePhotoIndex = _selectedPhotoIndex < galleryImages.length
        ? _selectedPhotoIndex
        : 0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: AppTypography.titleCard(color: AppColors.deepText)
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text(
              product.farmOrigin,
              style: AppTypography.labelSm(color: AppColors.mutedText)
                  .copyWith(fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.deepText),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing link for ${product.name}'),
                  backgroundColor: AppColors.primaryContainer,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.errorAlert : AppColors.deepText,
            ),
            onPressed: () => profileNotifier.toggleWishlist(product.id),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image Gallery with 1:1 Aspect Ratio & Verification Pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            galleryImages[activePhotoIndex],
                            fit: BoxFit.cover,
                          ),
                          // Floating Morning Harvest Verification Pill
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: AppColors.secondaryFixed,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Morning Harvest • 6:30 AM Today',
                                        style:
                                            AppTypography.labelSm(
                                              color: Colors.white,
                                            ).copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.pin_drop,
                                        size: 13,
                                        color: AppColors.primaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.farmOrigin,
                                        style: AppTypography.labelSm(
                                          color: AppColors.deepText,
                                        ).copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Counter Pill
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${activePhotoIndex + 1} / ${galleryImages.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Thumbnail Strip
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(galleryImages.length, (idx) {
                          final isSelected = activePhotoIndex == idx;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPhotoIndex = idx),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryContainer
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.network(
                                    galleryImages[idx],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Product Title, Rating & Price Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(16),
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 13,
                                color: AppColors.primaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '100% Traceable',
                                style:
                                    AppTypography.labelSm(
                                      color: AppColors.primaryContainer,
                                    ).copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Zero Wax Coating',
                            style:
                                AppTypography.labelSm(color: AppColors.deepText)
                                    .copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      style: AppTypography.headlineLgMobile(
                        color: AppColors.deepText,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: AppTypography.bodySm(color: AppColors.mutedText),
                    ),
                    const SizedBox(height: 10),
                    // Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '4.8',
                                style: AppTypography.labelSm(
                                  color: AppColors.deepText,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.star,
                                size: 13,
                                color: AppColors.primaryContainer,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '124 verified local family reviews',
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              CurrencyFormatter.format(effectivePrice),
                              style:
                                  AppTypography.headlineLgMobile(
                                    color: AppColors.primaryContainer,
                                  ).copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            if (originalPrice != null &&
                                originalPrice > effectivePrice) ...[
                              const SizedBox(width: 8),
                              Text(
                                CurrencyFormatter.format(originalPrice),
                                style:
                                    AppTypography.bodyMd(
                                      color: AppColors.mutedText,
                                    ).copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${(((originalPrice - effectivePrice) / originalPrice) * 100).round()}% OFF',
                                  style: AppTypography.labelSm(
                                    color: AppColors.deepText,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              selectedPack?.label ?? product.defaultPackSize,
                              style: AppTypography.labelSm(
                                color: AppColors.deepText,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Incl. of all taxes',
                              style: AppTypography.labelSm(
                                color: AppColors.mutedText,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Variant Selector (Pack Sizes)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Pack Size',
                        style: AppTypography.headlineSm(
                          color: AppColors.deepText,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Freshness Guaranteed',
                        style: AppTypography.labelSm(
                          color: AppColors.primaryContainer,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(packOptions.length, (idx) {
                      final item = packOptions[idx];
                      final isSelected = selectedPackIndex == idx;
                      final hasSavings =
                          item.originalPrice != null &&
                          item.originalPrice! > item.price;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPackIndex = idx),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: idx < packOptions.length - 1 ? 8 : 0,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.softGreen
                                  : AppColors.whiteSurface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.borderSubtle.withValues(
                                        alpha: 0.6,
                                      ),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: AppTypography.labelLg(
                                          color: AppColors.deepText,
                                        ).copyWith(fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        size: 15,
                                        color: AppColors.primaryContainer,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(item.price),
                                  style: AppTypography.titleCard(
                                    color: AppColors.primaryContainer,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasSavings
                                      ? 'Save ${CurrencyFormatter.format(item.originalPrice! - item.price)}'
                                      : (item.isDefault
                                            ? 'Popular Choice'
                                            : 'Fresh Harvest'),
                                  style: AppTypography.labelSm(
                                    color: AppColors.mutedText,
                                  ).copyWith(fontSize: 10),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 4. Delivery & Cold-Chain Reassurance Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.electric_moped,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Express Delivery to Sedam Road',
                                    style: AppTypography.labelLg(
                                      color: AppColors.deepText,
                                    ).copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.softGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Today by 3:00 PM',
                                  style:
                                      AppTypography.labelSm(
                                        color: AppColors.primaryContainer,
                                      ).copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Order within 42 mins to get today's sunrise harvest batch.",
                                style: AppTypography.bodySm(
                                  color: AppColors.mutedText,
                                ).copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTrustBadge(
                            icon: Icons.schedule,
                            title: 'Within 12 Hrs',
                            sub: 'From picking',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildTrustBadge(
                            icon: Icons.agriculture,
                            title: 'Direct Farm',
                            sub: 'Zero middlemen',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildTrustBadge(
                            icon: Icons.thermostat,
                            title: 'No Chilling',
                            sub: 'Natural ambient',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 5. Farmer & Harvest Provenance Card ("Know Your Grower")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(16),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.nature_people,
                              size: 20,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Know Your Grower',
                              style: AppTypography.headlineSm(
                                color: AppColors.deepText,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          'Batch #HO-8241',
                          style: AppTypography.labelSm(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBTSXSesCDaNhuLtVrBCEYhlSVCJ4lsmCyOPiOwEP7-RJQ4f77ZFVPCd0hXfqZlSsvDOE8Vm8wKKIQjw5324wJETgh_Ff0ryEEMrbLB9Q0hoJ864a_783v1Dwp26_n_S_uunZj404LMSxEJIShbV09IbDvFwT_1HtATc8wE9V8KXm2ugEZs_naM9FAroph2-u-Z_T9VdD77fJUe6sRdrX6Y9tGWJ_9Rk9fzfwsY4DEL8Fp1-aNMfAKi',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Basavaraj Patil',
                                      style: AppTypography.titleCard(
                                        color: AppColors.deepText,
                                      ).copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.check_circle,
                                      size: 15,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ],
                                ),
                                Text(
                                  'Patil Heritage Farm, Sedam Belt',
                                  style: AppTypography.bodySm(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                                Text(
                                  '14 km from Kalaburagi Depot',
                                  style:
                                      AppTypography.labelSm(
                                        color: AppColors.secondary,
                                      ).copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Soil Composition',
                                  style: AppTypography.labelSm(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                                Text(
                                  'Deep Black Cotton',
                                  style:
                                      AppTypography.labelLg(
                                        color: AppColors.deepText,
                                      ).copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Irrigation',
                                  style: AppTypography.labelSm(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                                Text(
                                  'Sweet Open Well',
                                  style:
                                      AppTypography.labelLg(
                                        color: AppColors.deepText,
                                      ).copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 90),
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
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CurrencyFormatter.format(effectivePrice),
                      style: AppTypography.headlineLgMobile(
                        color: AppColors.primaryContainer,
                      ).copyWith(fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                    Text(
                      '${selectedPack?.label ?? product.defaultPackSize} • Incl. taxes',
                      style: AppTypography.labelSm(color: AppColors.mutedText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (qty == 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    cartNotifier.addItem(product, pack: selectedPack);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${product.name} to basket'),
                        backgroundColor: AppColors.primaryContainer,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Add to Basket',
                        style: AppTypography.labelLg(color: Colors.white)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    QuantityStepper(
                      quantity: qty,
                      onIncrement: () =>
                          cartNotifier.addItem(product, pack: selectedPack),
                      onDecrement: () => cartNotifier.decrementItem(
                        product.id,
                        pack: selectedPack,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => context.push('/cart'),
                      child: const Text('View Cart'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadge({
    required IconData icon,
    required String title,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryContainer),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.labelSm(color: AppColors.deepText)
                .copyWith(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          Text(
            sub,
            style: AppTypography.labelSm(color: AppColors.mutedText)
                .copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
