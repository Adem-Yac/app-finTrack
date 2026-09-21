import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF16382C);
  static const Color logo = Color(0xFF21A65A);
  static const Color primaryDeep = Color(0xFF012D1D);
  static const Color primaryContainer = Color(0xFF1B4332);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF52796F);
  static const Color secondaryContainer = Color(0xFFBEE8DC);
  static const Color tertiary = Color(0xFF84A98C);
  static const Color sage = Color(0xFFCAD2C5);
  static const Color surface = Color(0xFFF9F8F5);
  static const Color surfaceLow = Color(0xFFF4F3F0);
  static const Color surfaceContainer = Color(0xFFEFEEEB);
  static const Color surfaceHigh = Color(0xFFE9E8E5);
  static const Color surfaceHighest = Color(0xFFE3E2E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A201C);
  static const Color onSurfaceVariant = Color(0xFF57635A);
  static const Color outline = Color(0xFF717973);
  static const Color outlineVariant = Color(0xFFE8E6DF);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorSoft = Color(0xFFC84B31);
  static const Color income = Color(0xFF1E7B4D);
  static const Color incomeSoft = Color(0xFFE8F5E9);
  static const Color expenseSoft = Color(0xFFFBEAE5);
  static const Color warning = Color(0xFFC4893B);
  static const Color canvas = Color(0xFFF9F8F5);
  static const Color muted = Color(0xFF8A948C);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x051B4332), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(color: Color(0x081B4332), offset: Offset(0, 6), blurRadius: 16),
  ];

  static const List<BoxShadow> floatShadow = [
    BoxShadow(color: Color(0x0A1B4332), offset: Offset(0, 4), blurRadius: 8),
    BoxShadow(color: Color(0x0F1B4332), offset: Offset(0, 12), blurRadius: 28),
  ];
}
