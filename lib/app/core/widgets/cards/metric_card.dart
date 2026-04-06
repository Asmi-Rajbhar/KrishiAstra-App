import 'dart:ui';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Widget buildMetricCard({
  required IconData icon,
  required Color iconColor,
  required String value,
  required String label,
  Color? backgroundColor,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withValues(alpha: 0.2),
                    iconColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.2)),
              ),
              child: Icon(
                icon,
                color: iconColor.withValues(alpha: 0.8),
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: AppSizes.fontTitle,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryColor.withValues(alpha: 0.5),
                fontSize: AppSizes.fontCaption - 2,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
