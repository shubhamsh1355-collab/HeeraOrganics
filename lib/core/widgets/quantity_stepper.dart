import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double height;
  final bool compact;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.height = 32.0,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return SizedBox(
        height: height,
        child: Material(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppRadii.radiusMd,
          child: InkWell(
            onTap: onIncrement,
            borderRadius: AppRadii.radiusMd,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 16),
              decoration: BoxDecoration(
                borderRadius: AppRadii.radiusMd,
                border: Border.all(
                  color: AppColors.primaryContainer,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ADD',
                    style: AppTypography.labelMd(
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.add,
                    size: 14,
                    color: AppColors.primaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadii.radiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(
              Icons.remove,
              size: 14,
              color: AppColors.onPrimary,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: height, minHeight: height),
            splashRadius: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$quantity',
              style: AppTypography.labelLg(color: AppColors.onPrimary),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 14, color: AppColors.onPrimary),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: height, minHeight: height),
            splashRadius: 16,
          ),
        ],
      ),
    );
  }
}
