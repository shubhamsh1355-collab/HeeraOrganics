import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_data.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories;
    final activeCategory = categories[_selectedCategoryIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Shop by Category',
          style: AppTypography.headlineSm(color: AppColors.deepText),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar for Main Categories
          Container(
            width: 95,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              border: Border(
                right: BorderSide(color: AppColors.borderSubtle, width: 1.0),
              ),
            ),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = index == _selectedCategoryIndex;
                return InkWell(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.surface
                          : Colors.transparent,
                      border: isSelected
                          ? const Border(
                              left: BorderSide(
                                color: AppColors.primaryContainer,
                                width: 4.0,
                              ),
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.softGreen
                                : AppColors.whiteSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(cat.id),
                            color: isSelected
                                ? AppColors.primaryContainer
                                : AppColors.mutedText,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          style: isSelected
                              ? AppTypography.labelSm(
                                  color: AppColors.primaryContainer,
                                )
                              : AppTypography.labelSm(
                                  color: AppColors.mutedText,
                                ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right Content Area: Banner & Subcategories
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: AppRadii.radiusMd,
                      border: Border.all(
                        color: AppColors.secondaryContainer,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeCategory.name,
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeCategory.bannerText,
                          style: AppTypography.bodySm(
                            color: AppColors.deepText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Subcategories',
                    style: AppTypography.labelLg(color: AppColors.deepText),
                  ),
                  const SizedBox(height: 10),

                  // Subcategory Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: activeCategory.subcategories.length,
                    itemBuilder: (context, index) {
                      final sub = activeCategory.subcategories[index];
                      return InkWell(
                        onTap: () {
                          context.push(
                            '/products?categoryId=${activeCategory.id}',
                          );
                        },
                        borderRadius: AppRadii.radiusMd,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.whiteSurface,
                            borderRadius: AppRadii.radiusMd,
                            border: Border.all(
                              color: AppColors.borderSubtle,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.eco,
                                  size: 20,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                sub.name,
                                style: AppTypography.labelSm(
                                  color: AppColors.deepText,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryContainer,
                        side: const BorderSide(
                          color: AppColors.primaryContainer,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.radiusMd,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        context.push(
                          '/products?categoryId=${activeCategory.id}',
                        );
                      },
                      child: Text('View All in ${activeCategory.name}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String catId) {
    switch (catId) {
      case 'cat_veg':
        return Icons.eco;
      case 'cat_dairy':
        return Icons.water_drop;
      case 'cat_fruits':
        return Icons.wb_sunny;
      case 'cat_staples':
        return Icons.grain;
      case 'cat_oils':
        return Icons.opacity;
      default:
        return Icons.shopping_basket;
    }
  }
}
