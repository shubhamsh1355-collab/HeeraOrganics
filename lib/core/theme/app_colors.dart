import 'package:flutter/material.dart';

/// Heera Organics Design System Color Tokens
/// Directly mapped from Stitch Design System (03_STITCH_DESIGN_SYSTEM.txt)
abstract class AppColors {
  // Brand Anchors
  static const Color primary = Color(0xFF093521); // Deep brand anchor
  static const Color primaryContainer = Color(
    0xFF234C36,
  ); // Forest green component action
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF8FBC9F);
  static const Color inversePrimary = Color(0xFFA4D1B4);

  // Surfaces & Canvas
  static const Color surface = Color(0xFFFFF8F1); // Warm parchment cream
  static const Color surfaceBright = Color(0xFFFFF8F1);
  static const Color surfaceDim = Color(0xFFE1D9CD);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(
    0xFFFBF3E7,
  ); // Toned cards/panels
  static const Color surfaceContainer = Color(0xFFF5EDE1);
  static const Color surfaceContainerHigh = Color(0xFFEFE7DB);
  static const Color surfaceContainerHighest = Color(0xFFE9E1D6);
  static const Color surfaceVariant = Color(0xFFE9E1D6);
  static const Color whiteSurface = Color(
    0xFFFFFFFF,
  ); // Clean product card surface

  // Text & Typography
  static const Color onSurface = Color(0xFF1E1B14);
  static const Color onSurfaceVariant = Color(0xFF414943);
  static const Color deepText = Color(0xFF243126); // Primary reading text
  static const Color mutedText = Color(0xFF706F63); // Secondary & pack metadata

  // Secondary & Accents
  static const Color secondary = Color(0xFF685F30);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(
    0xFFEDE0A5,
  ); // Harvest yellow promo tags
  static const Color harvestYellow = Color(0xFFEEE1A6); // Promo tag alternate
  static const Color onSecondaryContainer = Color(0xFF6C6333);

  // Soft Green & Seasonal Accents
  static const Color softGreen = Color(0xFFDBF5D1); // Benefits & selected chips
  static const Color tertiary = Color(0xFF1D3400);
  static const Color tertiaryContainer = Color(0xFF324B13);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color limeGreen = Color(
    0xFFD9FAAF,
  ); // Interactive spark / flash deals

  // Outlines & Borders
  static const Color outline = Color(0xFF717972);
  static const Color outlineVariant = Color(0xFFC1C8C1);
  static const Color borderSubtle = Color(0xFFE5DDCF); // Hairline 1px border

  // Errors & Alerts
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorAlert = Color(0xFFB42318);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
}
