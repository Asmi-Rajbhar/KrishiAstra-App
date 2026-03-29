import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// ActionCard
///
/// A reusable card widget designed for calls to action.
/// It features a header with an icon, a title, a subtitle, and a full-width action button.
///
/// Used in:
/// - `lifecycle_guide_card.dart`
/// - `climatic_requirements_page.dart`
class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.buttonColor,
    this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? AppColors.white;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.primaryColor).withValues(
              alpha: 0.2,
            ),
            blurRadius: AppSizes.md,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.xs),
                decoration: BoxDecoration(
                  color: effectiveTextColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.white,
                  size: AppSizes.iconLg,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: effectiveTextColor,
                        fontSize: AppSizes.fontTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: effectiveTextColor.withValues(alpha: 0.8),
                        fontSize: AppSizes.fontCaption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? AppColors.white,
                foregroundColor: buttonTextColor ?? AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: AppSizes.fontBody,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
