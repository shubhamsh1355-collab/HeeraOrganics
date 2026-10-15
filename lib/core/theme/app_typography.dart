import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Heera Organics Typography System
/// Editorial tactile serif styles using Literata and Source Serif 4
abstract class AppTypography {
  // Display & Headlines (Literata)
  static TextStyle displayHeroMobile({Color color = AppColors.deepText}) =>
      GoogleFonts.literata(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  static TextStyle headlineLgMobile({Color color = AppColors.deepText}) =>
      GoogleFonts.literata(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  static TextStyle headlineMd({Color color = AppColors.deepText}) =>
      GoogleFonts.literata(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  static TextStyle headlineSm({Color color = AppColors.deepText}) =>
      GoogleFonts.literata(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  static TextStyle titleCard({Color color = AppColors.deepText}) =>
      GoogleFonts.literata(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.375,
        color: color,
      );

  // Body & Metadata (Source Serif 4)
  static TextStyle bodyLg({Color color = AppColors.deepText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: color,
      );

  static TextStyle bodyMd({Color color = AppColors.deepText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle bodySm({Color color = AppColors.mutedText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.53,
        color: color,
      );

  // Labels & Actions (Source Serif 4)
  static TextStyle labelLg({Color color = AppColors.deepText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.42,
        color: color,
      );

  static TextStyle labelMd({Color color = AppColors.mutedText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  static TextStyle labelSm({Color color = AppColors.mutedText}) =>
      GoogleFonts.sourceSerif4(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: color,
      );

  // Price (Source Serif 4 tabular bold)
  static TextStyle price({
    Color color = AppColors.primaryContainer,
    double fontSize = 18,
  }) => GoogleFonts.sourceSerif4(
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
