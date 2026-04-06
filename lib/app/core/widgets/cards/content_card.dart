import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const ContentCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.child,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: AppSizes.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null || title.isNotEmpty)
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSizes.xs),
                    decoration: BoxDecoration(
                      color:
                          iconBackgroundColor ??
                          AppColors.greenShade.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primaryColor,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                ],
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
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: AppColors.grey600,
                            fontSize: AppSizes.fontCaption,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          if (icon != null || title.isNotEmpty)
            const SizedBox(height: AppSizes.md),
          child,
        ],
      ),
    );
  }
}
