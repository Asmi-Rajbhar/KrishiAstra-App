import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class NutrientSymptomItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const NutrientSymptomItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.grey100),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackShadow,
            blurRadius: AppSizes.sm,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: AppSizes.iconLg),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: AppSizes.fontBody,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.grey300),
        ],
      ),
    );
  }
}
