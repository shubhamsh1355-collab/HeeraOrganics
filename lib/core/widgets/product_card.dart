import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';
import '../utils/currency_formatter.dart';
import 'quantity_stepper.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String packSize;
  final num price;
  final num? originalPrice;
  final String imageUrl;
  final String? badgeText;
  final int quantity;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggleFavorite;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.packSize,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.badgeText,
    required this.quantity,
    this.isFavorite = false,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.radiusLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.radiusLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with 1:1 Aspect Ratio + Badges
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Container(
                        color: AppColors.surfaceContainerLow,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.surfaceContainerLow,
                                child: const Center(
                                  child: Icon(
                                    Icons.eco,
                                    size: 40,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),

                  // Promotional Badge (Harvest Yellow)
                  if (badgeText != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: AppRadii.radiusPill,
                        ),
                        child: Text(
                          badgeText!,
                          style: AppTypography.labelSm(
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Heart Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: AppColors.whiteSurface.withValues(alpha: 0.85),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onToggleFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite
                                ? AppColors.errorAlert
                                : AppColors.mutedText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Details & Action
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            packSize,
                            style: AppTypography.labelSm(
                              color: AppColors.mutedText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name,
                            style: AppTypography.titleCard(
                              color: AppColors.deepText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CurrencyFormatter.format(price),
                                style: AppTypography.price(
                                  color: AppColors.primaryContainer,
                                  fontSize: 16,
                                ),
                              ),
                              if (originalPrice != null &&
                                  originalPrice! > price)
                                Text(
                                  CurrencyFormatter.format(originalPrice!),
                                  style:
                                      AppTypography.labelSm(
                                        color: AppColors.mutedText,
                                      ).copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                            ],
                          ),
                          QuantityStepper(
                            quantity: quantity,
                            onIncrement: onIncrement,
                            onDecrement: onDecrement,
                            compact: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
