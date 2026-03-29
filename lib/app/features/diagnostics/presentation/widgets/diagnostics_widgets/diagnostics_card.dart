import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';

/// DiagnosticCard
///
/// A specialized card widget for displaying a diagnostic tool or category.
/// It features an icon, title, description, and a footer with a call to action.
/// It uses a `BaseCard` for its foundational styling.
///
/// Used in:
/// - `diagnostics_center_page.dart`
///
class DiagnosticCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String footer;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DiagnosticCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.footer,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container.
                Container(
                  width: AppSizes.xl * 2,
                  height: AppSizes.xl * 2,
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.2),
                        blurRadius: AppSizes.sm,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              icon,
                              color: AppColors.white,
                              size: AppSizes.iconLg,
                            ),
                          ),
                        )
                      : Icon(
                          icon,
                          color: AppColors.white,
                          size: AppSizes.iconLg,
                        ),
                ),
                const SizedBox(width: AppSizes.md),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: AppSizes.fontBody,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.grey600,
                          fontSize: AppSizes.fontCaption,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.grey50,
              border: Border(top: BorderSide(color: AppColors.grey100)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.radiusMd),
                bottomRight: Radius.circular(AppSizes.radiusMd),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  footer.toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey400,
                    letterSpacing: 0.5,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey400,
                  size: AppSizes.iconMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
