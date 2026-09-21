import 'package:flutter/material.dart';

class AppScale {
  AppScale._(this.width);

  factory AppScale.of(BuildContext context) {
    return AppScale._(MediaQuery.sizeOf(context).width);
  }

  final double width;

  bool get compact => width < 390;
  bool get isPhone => width < 640;
  bool get isTablet => width >= 640 && width < 1024;
  bool get isDesktop => width >= 1024;

  double get pagePadding => isDesktop
      ? 40
      : isTablet
      ? 24
      : 16;
  double get contentMax => isDesktop
      ? 1200
      : isTablet
      ? 840
      : 560;
  bool get twoCol => width >= 640;

  double get buttonHeight => isTablet ? 52 : 48;
  double get tileHeight => isTablet ? 68 : 60;
  double get navHeight => isTablet ? 76 : 68;

  double get iconSm => isTablet ? 18 : 16;
  double get iconMd => isTablet ? 24 : 20;
  double get iconLg => isTablet ? 30 : 24;
  double get navIcon => isTablet ? 26 : 22;
  double get fabIcon => isTablet ? 30 : 26;
  double get logo => isTablet
      ? 88
      : compact
      ? 72
      : 80;
  double get categoryBox => isTablet ? 48 : 42;
  double get avatar => isTablet ? 22 : 18;

  double get headlineXl => compact
      ? 28
      : isTablet
      ? 36
      : 32;
  double get headlineLg => isTablet ? 24 : 22;
  double get headlineMd => isTablet ? 20 : 18;
  double get headlineSm => 16;
  double get bodyLg => isTablet ? 16 : 15;
  double get bodyMd => 14;
  double get bodySm => 13;
  double get labelLg => 15;
  double get labelMd => 13;
  double get labelSm => 11;
  double get amountHero => compact
      ? 28
      : isTablet
      ? 36
      : 32;
  double get keypad => isTablet ? 22 : 20;
}
