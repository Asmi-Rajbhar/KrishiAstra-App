import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color titleColor;
  final Color actionTextColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.titleColor = AppColors.greenForeground,
    this.actionTextColor = AppColors.neonGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: AppSizes.fontHeading,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onActionPressed ?? () {},
              child: Text(
                actionText!,
                style: TextStyle(
                  color: actionTextColor,
                  fontSize: AppSizes.fontBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
