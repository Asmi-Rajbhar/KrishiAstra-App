import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

/// Builds a progress bar with glow effect and premium aesthetics
Widget buildProgressBar(double progress, Color color) {
  return Container(
    height: AppSizes.xs,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
    ),
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: progress,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: AppSizes.md,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ),
  );
}
