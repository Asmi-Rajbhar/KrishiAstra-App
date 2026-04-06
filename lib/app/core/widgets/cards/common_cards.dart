import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/widgets/cards/base_card.dart';
import 'package:krishiastra/app/core/widgets/layout/card_header.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';

/// CropCard
///
/// A specialized card for displaying information about a specific crop,
/// typically including an icon, title, description, and a call-to-action button.
/// It wraps its content within a `BaseCard`.
///
/// Used in:
/// - `home_widgets/crop_section.dart`
///
class CropCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback? onPressed;
  final String? duration;

  const CropCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    this.duration,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        children: [
          CardHeader(icon: icon, title: title, description: description),
          const SizedBox(height: AppSizes.sm),
          const Divider(height: AppSizes.xxs, color: AppColors.white),
          const SizedBox(height: AppSizes.md),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onPressed ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                elevation: 4,
                shadowColor: AppColors.primaryColor.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: AppSizes.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Icon(buttonIcon, size: AppSizes.iconMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// InfoCard
///
/// A simple card designed to display a key-value pair statistic,
/// with an accompanying icon, using a `BaseCard` for consistent styling.
///
/// Used in:
/// - `variety_detail_page.dart`
///
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primaryColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Container(
            width: AppSizes.xxl,
            height: AppSizes.xxl,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: primaryColor, size: AppSizes.lg),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: AppSizes.fontContent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
