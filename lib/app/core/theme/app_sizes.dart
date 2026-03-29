import 'package:flutter/material.dart';

/// Centralized size constants for the app.
class AppSizes {
  AppSizes._();

  // Spacing (Paddings / Margins)
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  // Border Radii
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusMax = 50.0;

  // Font Sizes
  static const double fontCaption = 11.0;
  static const double fontBody = 14.0;
  static const double fontContent = 16.0;
  static const double fontTitle = 18.0;
  static const double fontHeading = 24.0;
  static const double fontHero = 32.0;

  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 28.0;

  // Navigation
  static const double navBarHeight = 65.0;
  static const double buttonHeight = 50.0;

  // Common Layout Sizes
  static const double appBarHeight = 80.0;
  static const double cardHeaderHeight = 60.0;
}

/// Utility for quick EdgeInsets construction using AppSizes
class AppPadding {
  AppPadding._();

  static const EdgeInsets allXs = EdgeInsets.all(AppSizes.xs);
  static const EdgeInsets allSm = EdgeInsets.all(AppSizes.sm);
  static const EdgeInsets allMd = EdgeInsets.all(AppSizes.md);
  static const EdgeInsets allLg = EdgeInsets.all(AppSizes.lg);
  static const EdgeInsets allXl = EdgeInsets.all(AppSizes.xl);

  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(
    horizontal: AppSizes.md,
  );
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(
    horizontal: AppSizes.lg,
  );
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(
    vertical: AppSizes.md,
  );
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(
    vertical: AppSizes.sm,
  );
}
