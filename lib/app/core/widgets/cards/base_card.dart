import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// BaseCard
///
/// A foundational widget that provides a consistent visual container
/// with common styling such as background color, border radius, and shadow.
///
class BaseCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const BaseCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSizes.radiusLg,
          ),
          border: Border.all(color: AppColors.grey100),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: AppSizes.md,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: child,
      ),
    );
  }
}
