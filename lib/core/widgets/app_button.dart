import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primaryContainer;
        textColor = AppColors.onPrimary;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = AppColors.surfaceContainerLow;
        textColor = AppColors.primaryContainer;
        borderSide = const BorderSide(
          color: AppColors.primaryContainer,
          width: 1.0,
        );
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primaryContainer;
        break;
    }

    if (onPressed == null) {
      backgroundColor = AppColors.surfaceDim;
      textColor = AppColors.mutedText;
      borderSide = BorderSide.none;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: AppRadii.radiusMd,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadii.radiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: AppRadii.radiusMd,
              border: borderSide != BorderSide.none
                  ? Border.fromBorderSide(borderSide)
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 18, color: textColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: AppTypography.labelLg(color: textColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
