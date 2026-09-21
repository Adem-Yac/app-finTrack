import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static bool _ar(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static TextStyle _base(
    BuildContext context, {
    required double size,
    required FontWeight weight,
    double height = 1.4,
    double letterSpacing = 0,
    Color? color,
    bool tabular = false,
  }) {
    final style = TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.onSurface,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
    return _ar(context)
        ? GoogleFonts.cairo(textStyle: style)
        : GoogleFonts.plusJakartaSans(textStyle: style);
  }

  static TextStyle headlineXl(
    BuildContext context, {
    Color? color,
    bool tabular = false,
  }) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.headlineXl,
      weight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.6,
      color: color,
      tabular: tabular,
    );
  }

  static TextStyle headlineLg(
    BuildContext context, {
    Color? color,
    bool tabular = false,
  }) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.headlineLg,
      weight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.3,
      color: color,
      tabular: tabular,
    );
  }

  static TextStyle headlineMd(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.headlineMd,
      weight: FontWeight.w600,
      height: 1.35,
      letterSpacing: -0.2,
      color: color,
    );
  }

  static TextStyle headlineSm(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.headlineSm,
      weight: FontWeight.w600,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle bodyLg(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.bodyLg,
      weight: FontWeight.w400,
      height: 1.5,
      color: color ?? AppColors.onSurfaceVariant,
    );
  }

  static TextStyle bodyMd(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.bodyMd,
      weight: FontWeight.w400,
      height: 1.5,
      color: color ?? AppColors.onSurfaceVariant,
    );
  }

  static TextStyle bodySm(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.bodySm,
      weight: FontWeight.w400,
      height: 1.4,
      color: color ?? AppColors.muted,
    );
  }

  static TextStyle labelLg(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.labelLg,
      weight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.1,
      color: color,
    );
  }

  static TextStyle labelMd(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.labelMd,
      weight: FontWeight.w600,
      height: 1.35,
      color: color ?? AppColors.onSurfaceVariant,
    );
  }

  static TextStyle labelSm(BuildContext context, {Color? color}) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: s.labelSm,
      weight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0.4,
      color: color ?? AppColors.muted,
    );
  }

  static TextStyle amount(
    BuildContext context, {
    Color? color,
    bool hero = false,
  }) {
    final s = AppScale.of(context);
    return _base(
      context,
      size: hero ? s.amountHero : s.headlineMd,
      weight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.4,
      color: color,
      tabular: true,
    );
  }
}
