import 'package:flutter/material.dart';

/// Centralized app color definitions used across the app.
class AppColors {
  AppColors._();
  static const Color greenShade = Color(0xFF43A047);
  static const Color primaryColor = Color(0xFF0A2E1A);
  static const Color accentGreen = Color(0xFF1E7944);
  static const Color backgroundLight = Color(0xFFF8F9F7);
  static const Color redShade = Color(0xFFE53935);
  static const Color orangeShade = Color(0xFFEA580C);
  static const Color yellowShade = Color(0xFFCA8A04);
  static const Color lightYellow = Color(0xFFFBBF24);

  static const Color blueShade = Color(0xFF2563EB);
  static const Color black = Color(0xFF000000);
  static const Color greenForeground = Color(0xFF0A4D2E);
  static const Color lightBlue = Color(0xFF94A3B8);

  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color black26 = Color(0x42000000);
  static const Color error = Color(0xFFE53935); // Mapping to redShade
  static const Color success = Color(0xFF43A047); // Mapping to greenShade
  static const Color warning = Color(0xFFEA580C); // Mapping to orangeShade
  static const Color info = Color(0xFF2563EB); // Mapping to blueShade
  static const Color warningLight = Color(0xFFFFE0B2); // Aliasing orange100
  static const Color blackShadow = Color(
    0x08000000,
  ); // Very light black for shadows

  // Grey Shades
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color greyShade = Color(
    0xFF757575,
  ); // Kept for backward compatibility

  // Additional Colors found in codebase
  static const Color darkBackground = Color(0xFF111812);
  static const Color explorerBackground = Color(0xFF112112);
  static const Color neonGreen = Color(0xFF19E62B);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate500 = Color(0xFF64748B);

  // Specific Shades
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color orange100 = Color(0xFFFFE0B2);
  static const Color red100 = Color(0xFFFFCDD2);

  static const Color red700 = Color(0xFFD32F2F);
  static const Color blue800 = Color(0xFF1565C0);
  static const Color orange800 = Color(0xFFEF6C00);
  static const Color green800 = Color(0xFF2E7D32);

  // Background Refinement Tokens
  static const Color softGreen = Color(0xFF8ED785);
  static const Color warmGrey = Color(0xFFF4F0F0);
  static const Color cotton = Color(0xFFECE3E3);
}

// 1. Define custom color scheme using ThemeExtension
@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.primary,
    required this.accentGreen,
    required this.backgroundLight,
  });

  final Color primary;
  final Color accentGreen;
  final Color backgroundLight;

  @override
  AppColorExtension copyWith({
    Color? primary,
    Color? accentGreen,
    Color? backgroundLight,
  }) {
    return AppColorExtension(
      primary: primary ?? this.primary,
      accentGreen: accentGreen ?? this.accentGreen,
      backgroundLight: backgroundLight ?? this.backgroundLight,
    );
  }

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension>? other, double t) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
    );
  }
}

// 2. Define your light and dark themes
final appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  fontFamily: 'Lexend',
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    primary: AppColors.primaryColor,
  ),
  extensions: const <ThemeExtension<dynamic>>[
    AppColorExtension(
      primary: AppColors.primaryColor,
      accentGreen: AppColors.accentGreen,
      backgroundLight: AppColors.backgroundLight,
    ),
  ],
);
