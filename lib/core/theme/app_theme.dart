import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// Heera Organics ThemeData
/// Warm naturalism, cream canvas, forest green accents, 1px subtle borders
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,
      primaryColor: AppColors.primaryContainer,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.outline,
        outlineVariant: AppColors.borderSubtle,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.deepText),
        titleTextStyle: AppTypography.headlineSm(color: AppColors.deepText),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.whiteSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
        elevation: 0,
        modalBackgroundColor: AppColors.whiteSurface,
        modalBarrierColor: Color(0x66243126), // Deep forest charcoal scrim
      ),
      cardTheme: CardThemeData(
        color: AppColors.whiteSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.radiusLg,
          side: const BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.whiteSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(
            color: AppColors.borderSubtle,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(
            color: AppColors.borderSubtle,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusMd,
          borderSide: const BorderSide(color: AppColors.errorAlert, width: 1.0),
        ),
        hintStyle: AppTypography.bodyMd(color: AppColors.mutedText),
        labelStyle: AppTypography.labelMd(color: AppColors.mutedText),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
