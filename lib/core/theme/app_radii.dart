import 'package:flutter/material.dart';

/// Heera Organics Border Radii
/// Level 2 subtle tactile curves from Stitch Design System
abstract class AppRadii {
  static const double sm = 4.0;
  static const double base = 8.0;
  static const double md = 12.0; // Input fields, CTA buttons, steppers
  static const double lg = 16.0; // Product cards, bottom sheets
  static const double xl = 24.0;
  static const double pill = 9999.0; // Chips, badges, counter tags

  // BorderRadius helpers
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusBase = BorderRadius.all(
    Radius.circular(base),
  );
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusPill = BorderRadius.all(
    Radius.circular(pill),
  );

  // Sheet top radius
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
