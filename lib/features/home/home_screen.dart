import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/product.dart';
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
      'tag': 'Freshness • Responsible Sourcing • Farm-to-Home',
      'tagIcon': 'verified',
      'title': 'Good Food Begins at the Farm.',
      'subtitle': 'From our regional partner fields to your family kitchen in Kalaburagi. Fresh groceries, cold-pressed staples, and artisanal dairy delivered with care.',
      'primaryCta': 'Shop Fresh Now',
      'secondaryCta': 'Our Story',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA3vYZcOU0xI0orINMWV1771Inn88K3RdYkRBDRGPPelDfWz02YAODFOUsBRp4urU5tu_MsVTjGQoT3BmhpCcagtYEqJqAWjtr0yMyXCnod3lRehBF4upT_R-F9icVWOtpqXGrN8Kc28qnwsTZXv1r-01bUTDoZ6UXhBKMMW_OAb9AQBTp6WCnTPhjKZPoExY8ADbT5sYVXo5WKr7VcL8S1IF1dTvlGI0BV8mEdiaQLchDMwLTygK9t',
    },
    {
      'tag': '100% Pesticide Free • Chemical-Free Soil',
      'tagIcon': 'spa',
      'title': 'Naturally Grown, Honestly Delivered.',
      'subtitle': 'Cultivated with pure regenerative farming traditions. Certified pure, lab-tested harvests brought directly to Kalaburagi homes.',
      'primaryCta': 'Explore Produce',
      'secondaryCta': 'Meet Farmers',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC31BHKCdeoNeMIWo3Z-vidqf0-ugs5NtTj8WK-TCUNfg5VhcohHIeMmTrmBOwMatqjgm-6rKeRTHj6DQbUfO97DOZGBcLr-3AZEaPd6IrlrE5rgNSoejZcr0JO0EoAGGJjmU4Q2jWF4kjvJV6IfEqG01UhR4eS7_FLCtwwZAaxbGkX3b-l8CSizv4CRQXi5DXRebWBlBeUej-kUI1okiUYxYf8jeuL2-se72O3HeFHsf9NtjyJ6hnY',
    },
    {
      'tag': 'Harvested at Dawn • Doorstep by 7 AM',
      'tagIcon': 'local_shipping',
      'title': 'Fresh Morning Harvest to Your Doorstep.',
      'subtitle': 'Enjoy Desi Gir cow milk, farm paneer, unpolished pulses, and sun-ripened orchard fruits before your morning tea is brewed.',
      'primaryCta': 'Order Essentials',
      'secondaryCta': 'Daily Plans',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDhKYAxPZe6j03IEdWza5VaAnIzNuSXwG5W0EUWNncMPHyHVyLM7qvPcgAydfrYu0Rhh7NssTrACR062APR22M5vPzE9i6sEmoU4I_j4GTIRAuMIl9pVe3ZKsKwcgFtXR0LNUNFbECb10P420QEzbzz6j56Md2ET-n26iVfHbIk4nNWfdT0h6Kbzd6pUm3jlJpzCTSfyU_SPgaT_D-5-AZoaDmXVapaLieueNWP5pmCHB5Jiq3bobeR',
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 16,
        backgroundColor: AppColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        title: Row(
          children: [
            // Official Brand Logo in Circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderSubtle.withValues(alpha: 0.7),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: Image.network(
                  MockData.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.spa, color: AppColors.primary, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Heera Organics',
                    style: AppTypography.titleCard(color: AppColors.deepText)
                        .copyWith(fontSize: 17, fontWeight: FontWeight.w700),
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
                          ).copyWith(fontSize: 11),
                        ),
                        Flexible(
                          child: Text(
                            profileState.selectedAddress.locality,
                            style:
                                AppTypography.labelMd(color: AppColors.deepText)
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.expand_more,
                          size: 15,
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
                  size: 24,
                ),
                onPressed: () => context.push('/cart'),
              ),
              if (cartState.totalItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
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
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar with Dynamic Ticker & Mic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: InkWell(
                onTap: () => context.go('/search'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepText.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                          'Search unpolished toor dal…',
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

            // Quick Links Horizontal Category Pills
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 8),
              child: SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildQuickChip(
                      icon: Icons.apps,
                      label: 'All',
                      bgColor: AppColors.primaryContainer,
                      iconColor: Colors.white,
                      onTap: () => context.go('/categories'),
                    ),
                    _buildQuickChip(
                      icon: Icons.eco,
                      label: 'Vegetables',
                      bgColor: const Color(0xFFE8F5E9),
                      iconColor: AppColors.primaryContainer,
                      onTap: () => context.push('/products?categoryId=cat_veg'),
                    ),
                    _buildQuickChip(
                      icon: Icons.water_drop,
                      label: 'Fresh Dairy',
                      bgColor: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0284C7),
                      onTap: () =>
                          context.push('/products?categoryId=cat_dairy'),
                    ),
                    _buildQuickChip(
                      icon: Icons.local_florist,
                      label: 'Fruits',
                      bgColor: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      onTap: () =>
                          context.push('/products?categoryId=cat_fruits'),
                    ),
                    _buildQuickChip(
                      icon: Icons.grass,
                      label: 'Staples',
                      bgColor: const Color(0xFFFEF9C3),
                      iconColor: const Color(0xFF854D0E),
                      onTap: () =>
                          context.push('/products?categoryId=cat_staples'),
                    ),
                    _buildQuickChip(
                      icon: Icons.storefront,
                      label: 'Essentials',
                      bgColor: const Color(0xFFF1F5F9),
                      iconColor: const Color(0xFF475569),
                      onTap: () =>
                          context.push('/products?categoryId=cat_essentials'),
                    ),
                    _buildQuickChip(
                      icon: Icons.local_offer,
                      label: 'Offers',
                      bgColor: const Color(0xFFFEF2F2),
                      iconColor: const Color(0xFFDC2626),
                      onTap: () => context.push('/products'),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Animated & Dynamic Interactive Hero Carousel (340px)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                height: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepText.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _heroController,
                      itemCount: _heroSlides.length,
                      onPageChanged: (idx) =>
                          setState(() => _activeHeroIndex = idx),
                      itemBuilder: (context, index) {
                        final slide = _heroSlides[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              slide['imageUrl']!,
                              fit: BoxFit.cover,
                            ),
                            // Dark gradient overlay
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.deepText.withValues(alpha: 0.70),
                                    AppColors.deepText.withValues(alpha: 0.95),
                                  ],
                                  stops: const [0.2, 0.6, 1.0],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: AppColors.secondaryFixed,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          slide['tag']!.toUpperCase(),
                                          style:
                                              AppTypography.labelSm(
                                                color: AppColors.secondaryFixed,
                                              ).copyWith(
                                                fontSize: 10,
                                                letterSpacing: 0.8,
                                                fontWeight: FontWeight.w700,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    slide['title']!,
                                    style:
                                        AppTypography.headlineLgMobile(
                                          color: Colors.white,
                                        ).copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    slide['subtitle']!,
                                    style: AppTypography.bodySm(
                                      color: AppColors.surfaceVariant
                                          .withValues(alpha: 0.9),
                                    ).copyWith(height: 1.3),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryContainer,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: () =>
                                            context.push('/products'),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              slide['primaryCta']!,
                                              style:
                                                  AppTypography.labelMd(
                                                    color: Colors.white,
                                                  ).copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: AppColors.surface
                                              .withValues(alpha: 0.9),
                                          foregroundColor:
                                              AppColors.primaryContainer,
                                          side: BorderSide.none,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                        ),
                                        onPressed: () => context.push('/faqs'),
                                        child: Text(
                                          slide['secondaryCta']!,
                                          style:
                                              AppTypography.labelMd(
                                                color:
                                                    AppColors.primaryContainer,
                                              ).copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // Slide indicators & quick arrows
                    Positioned(
                      bottom: 8,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              _heroSlides.length,
                              (idx) => Container(
                                width: _activeHeroIndex == idx ? 22 : 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: _activeHeroIndex == idx
                                      ? AppColors.secondaryFixed
                                      : Colors.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_activeHeroIndex > 0) {
                                    _heroController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  if (_activeHeroIndex <
                                      _heroSlides.length - 1) {
                                    _heroController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Category Grid: "Fresh Choices for Every Day"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fresh Choices for Every Day',
                    style: AppTypography.headlineSm(color: AppColors.deepText),
                  ),
                  InkWell(
                    onTap: () => context.go('/categories'),
                    child: Row(
                      children: [
                        Text(
                          'Explore All',
                          style: AppTypography.labelMd(
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: AppColors.primaryContainer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.78,
                ),
                itemCount: MockData.categories.length,
                itemBuilder: (context, index) {
                  final cat = MockData.categories[index];
                  return InkWell(
                    onTap: () => context.push('/products?categoryId=${cat.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                cat.iconUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            style: AppTypography.labelMd(
                              color: AppColors.deepText,
                            ).copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 4. Featured Promotional Cards ("Fresh Picks, Special Offers")
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fresh Picks, Special Offers',
                    style: AppTypography.headlineSm(color: AppColors.deepText),
                  ),
                  Text(
                    'Updated daily',
                    style: AppTypography.labelSm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 145,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Promo 1: Morning Harvest Picks
                  Container(
                    width: 270,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.deepText,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '15% Off First Basket',
                                style: AppTypography.labelSm(
                                  color: Colors.white,
                                ).copyWith(fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Morning Harvest Picks',
                              style: AppTypography.headlineSm(
                                color: AppColors.deepText,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Dew-fresh greens picked at dawn and packed for your doorstep.',
                              style: AppTypography.bodySm(
                                color: AppColors.onSecondaryContainer,
                              ).copyWith(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => context.push('/products'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepText,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop Seasonal',
                                  style: AppTypography.labelSm(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Promo 2: Farm Fresh Dairy
                  Container(
                    width: 270,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Pure & Fresh',
                                style: AppTypography.labelSm(
                                  color: Colors.white,
                                ).copyWith(fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Farm Fresh Dairy',
                              style: AppTypography.headlineSm(
                                color: AppColors.deepText,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Desi A2 Milk & slow-cooked Bilona Ghee made daily.',
                              style: AppTypography.bodySm(
                                color: AppColors.deepText.withValues(
                                  alpha: 0.8,
                                ),
                              ).copyWith(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              context.push('/products?categoryId=cat_dairy'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop Dairy',
                                  style: AppTypography.labelSm(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 5. Trending Now Slider
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Trending Now',
                        style: AppTypography.headlineSm(
                          color: AppColors.deepText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.push('/products'),
                    child: Text(
                      'See All →',
                      style: AppTypography.labelMd(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 236,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5.clamp(0, MockData.products.length),
                itemBuilder: (context, index) {
                  final product = MockData.products[index];
                  return _buildTrendingCard(context, product, cartNotifier);
                },
              ),
            ),

            // 6. Farm-To-Family Story Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OUR HERITAGE',
                            style:
                                AppTypography.labelSm(
                                  color: AppColors.primaryContainer,
                                ).copyWith(
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'From Our Farm to Your Family.',
                            style: AppTypography.headlineLgMobile(
                              color: AppColors.deepText,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'At Heera Organics, we believe that good food begins with good farming. We cultivate clean produce without shortcut chemicals and partner with family farms around Kalaburagi to bring honesty back to your kitchen.',
                            style: AppTypography.bodyMd(
                              color: AppColors.deepText.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => context.push('/faqs'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Learn About Our Farms',
                                  style: AppTypography.labelLg(
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.east,
                                  size: 16,
                                  color: AppColors.primaryContainer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuC31BHKCdeoNeMIWo3Z-vidqf0-ugs5NtTj8WK-TCUNfg5VhcohHIeMmTrmBOwMatqjgm-6rKeRTHj6DQbUfO97DOZGBcLr-3AZEaPd6IrlrE5rgNSoejZcr0JO0EoAGGJjmU4Q2jWF4kjvJV6IfEqG01UhR4eS7_FLCtwwZAaxbGkX3b-l8CSizv4CRQXi5DXRebWBlBeUej-kUI1okiUYxYf8jeuL2-se72O3HeFHsf9NtjyJ6hnY',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 7. Fresh Dairy & Daily Essentials Slider
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fresh Dairy & Essentials',
                        style: AppTypography.headlineSm(
                          color: AppColors.deepText,
                        ),
                      ),
                      Text(
                        'Zero preservatives • Shipped cold',
                        style: AppTypography.labelSm(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.push('/products?categoryId=cat_dairy'),
                    child: Text(
                      'View All →',
                      style: AppTypography.labelMd(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 236,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockData.products
                    .where((p) => p.categoryId == 'cat_dairy')
                    .length,
                itemBuilder: (context, index) {
                  final product = MockData.products
                      .where((p) => p.categoryId == 'cat_dairy')
                      .toList()[index];
                  return _buildTrendingCard(context, product, cartNotifier);
                },
              ),
            ),

            // 8. Thoughtful Comparison Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF2E6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderSubtle.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'BETTER FOR YOU',
                      style:
                          AppTypography.labelSm(
                            color: AppColors.primaryContainer,
                          ).copyWith(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A More Thoughtful Way to Shop',
                      style: AppTypography.headlineSm(color: AppColors.deepText)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    // Comparison 1
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.softGreen.withValues(
                                  alpha: 0.25,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: AppColors.primaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Heera Organics',
                                        style: AppTypography.labelSm(
                                          color: AppColors.primaryContainer,
                                        ).copyWith(fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Harvested & at your door under 24 hours',
                                    style: AppTypography.bodySm(
                                      color: AppColors.deepText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Conventional Market',
                                    style: AppTypography.labelSm(
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Sitting in supply chains for 4-7 days',
                                    style: AppTypography.bodySm(
                                      color: AppColors.mutedText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelSm(color: AppColors.deepText)
                  .copyWith(fontSize: 11, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingCard(
    BuildContext context,
    Product product,
    CartNotifier cartNotifier,
  ) {
    return InkWell(
      onTap: () => context.push('/products/${product.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 165,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderSubtle.withValues(alpha: 0.6),
            width: 1.0,
          ),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1.05,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                if (product.badgeText != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        product.badgeText!,
                        style: AppTypography.labelSm(
                          color: AppColors.primaryContainer,
                        ).copyWith(fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.defaultPackSize,
              style: AppTypography.labelSm(color: AppColors.mutedText)
                  .copyWith(fontSize: 10),
            ),
            Text(
              product.name,
              style: AppTypography.titleCard(color: AppColors.deepText)
                  .copyWith(fontSize: 13, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(product.price),
                  style: AppTypography.headlineSm(
                    color: AppColors.primaryContainer,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    cartNotifier.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${product.name} to basket'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.primaryContainer,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add',
                        style: AppTypography.labelSm(
                          color: Colors.white,
                        ).copyWith(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.add, size: 13),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
