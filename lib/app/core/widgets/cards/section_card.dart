import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// SectionCard
///
/// A specialized card widget designed to serve as a container for
/// sections of content within a screen. It provides a title, an icon,
/// and consistent styling for visually grouping related information.
///
/// Used in:
/// - `lib/widgets/layout/info_section.dart`
///
class SectionCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: padding ?? const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: AppSizes.md,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Standard Header
          Row(
            children: [
              icon,
              const SizedBox(width: AppSizes.sm),
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
            ],
          ),
          const SizedBox(height: AppSizes.md),
          child,
        ],
      ),
    );
  }
}
