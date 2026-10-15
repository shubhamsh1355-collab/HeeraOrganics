import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.softGreen
        : AppColors.whiteSurface;
    final borderColor = isSelected
        ? AppColors.primaryContainer
        : AppColors.borderSubtle;
    final textColor = isSelected
        ? AppColors.primaryContainer
        : AppColors.mutedText;

    return Material(
      color: backgroundColor,
      borderRadius: AppRadii.radiusPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radiusPill,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: AppRadii.radiusPill,
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(label, style: AppTypography.labelMd(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
