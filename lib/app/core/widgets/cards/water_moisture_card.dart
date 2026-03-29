import 'dart:ui';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/cards/progressbar.dart';
import 'package:flutter/material.dart';

/// Builds an extremely simplified, beautiful side-by-side water metrics card
Widget buildWaterMoistureCard({Map<String, dynamic>? data}) {
  final rainfall = data?['annual_requirement'] ?? '1500-2500';
  final humidity = data?['humidity_during_growth'] ?? '70% - 85%';

  return ClipRRect(
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: AppSizes.lg,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Single Line Header
            const Row(
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.accentGreen,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  'Water & Moisture Requirements',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontContent,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // 2. Side-by-Side Metrics
            Row(
              children: [
                Expanded(
                  child: _buildSimpleMetricColumn(
                    label: 'Rainfall',
                    value: rainfall,
                    unit: 'mm',
                    progress: 0.75,
                    color: Colors.blueAccent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.primaryColor.withValues(alpha: 0.05),
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                ),
                Expanded(
                  child: _buildSimpleMetricColumn(
                    label: 'Humidity',
                    value: humidity,
                    unit: '',
                    progress: 0.82,
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSimpleMetricColumn({
  required String label,
  required String value,
  required String unit,
  required double progress,
  required Color color,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppColors.primaryColor.withValues(alpha: 0.5),
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: AppSizes.xs),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value.contains(' ')
                  ? value.split(' ')[0]
                  : value.split('-')[0],
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: AppSizes.fontTitle,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (unit.isNotEmpty)
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                  fontSize: AppSizes.fontCaption,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSizes.sm),
      buildProgressBar(progress, color),
    ],
  );
}
