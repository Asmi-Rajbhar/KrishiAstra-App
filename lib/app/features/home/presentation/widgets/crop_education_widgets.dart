import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class CropEducationWidgets {
  static Widget buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.neonGreen, size: AppSizes.iconXl),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppSizes.fontBody,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontCaption,
              color: AppColors.primaryColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSuitabilityItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.accentGreen,
            size: AppSizes.iconLg,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppSizes.fontCaption,
                color: AppColors.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: AppSizes.fontBody,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildLifecycleStep({
    required String stage,
    required String description,
    required IconData icon,
    bool isLast = false,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppSizes.md),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.grey100, // Using a light background
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.neonGreen,
                width: AppSizes.xxs,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: AppSizes.iconXl,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            stage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontCaption,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            description,
            style: TextStyle(
              fontSize: AppSizes.fontCaption,
              color: AppColors.primaryColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget buildEconomicCard(
    BuildContext context, {
    required String income,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: AppSizes.sm + 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_rupee,
              color: AppColors.white,
              size: AppSizes.iconXl,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Potential Income',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  income,
                  style: const TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: AppSizes.fontHero,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'per acre / harvest',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildRiskCard({
    required String title,
    required String type, // 'Pest' or 'Disease'
  }) {
    final isPest = type == 'Pest';
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border(
          left: BorderSide(
            color: isPest ? AppColors.warning : AppColors.error,
            width: AppSizes.xs,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isPest ? Icons.adb : Icons.coronavirus,
            color: isPest ? AppColors.warning : AppColors.error,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontBody,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    fontSize: AppSizes.fontCaption,
                    color: AppColors.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildIntensityIndicator({
    required String label,
    required String value, // Low, Medium, High
  }) {
    Color color;
    double percent;
    if (value.toLowerCase() == 'high') {
      color = AppColors.error;
      percent = 1.0;
    } else if (value.toLowerCase() == 'medium') {
      color = AppColors.warning;
      percent = 0.66;
    } else {
      color = AppColors.success;
      percent = 0.33;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: AppColors.grey200,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
