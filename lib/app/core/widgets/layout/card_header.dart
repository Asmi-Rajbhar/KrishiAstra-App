import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';

/// CardHeader
///
/// A reusable header component for cards, typically featuring an icon,
/// a title, an optional description, and an optional badge.
/// It provides a consistent look for card headings.
///
/// Used in:
/// - `diagnostic_details_page.dart`
/// - `widgets/cards/common_cards.dart` (specifically within `CropCard`)
///
class CardHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? description;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const CardHeader({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: AppSizes.xxl,
            height: AppSizes.xxl,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  blurRadius: AppSizes.sm,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.white, size: AppSizes.lg),
          ),
          const SizedBox(width: AppSizes.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: AppSizes.fontTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (badgeText != null)
                    Container(
                      margin: const EdgeInsets.only(left: AppSizes.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor ?? AppColors.red100,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        badgeText!.toUpperCase(),
                        style: TextStyle(
                          color: badgeTextColor ?? AppColors.red700,
                          fontSize: AppSizes.fontCaption,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: AppSizes.xs),
                Text(
                  description!,
                  style: const TextStyle(
                    color: AppColors.greyShade,
                    fontSize: AppSizes.fontBody,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
