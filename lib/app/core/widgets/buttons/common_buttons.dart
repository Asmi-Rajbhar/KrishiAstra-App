import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';

/// AppOutlinedButton
///
/// A customizable outlined button with an optional icon.
/// Designed for secondary actions or options where a less prominent
/// visual than a filled button is desired.
///
/// Used in:
/// - `lifecycle_widgets/lifecycle_card.dart`
///
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final IconData? icon;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.transparent,
    required this.foregroundColor,
    this.borderColor = AppColors.grey400,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppSizes.fontContent,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSizes.sm),
              Icon(icon, size: AppSizes.iconMd),
            ],
          ],
        ),
      ),
    );
  }
}

/// PrimaryActionButton
///
/// A prominent, filled button with an optional icon,
/// typically used for primary actions or calls to action on a screen.
///
/// Used in:
/// - `diagnostic_details_page.dart`
///
class PrimaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, size: AppSizes.iconMd)
          : const SizedBox.shrink(),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        elevation: 4,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
}
