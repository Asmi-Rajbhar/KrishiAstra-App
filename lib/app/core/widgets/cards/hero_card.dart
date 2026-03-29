import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';
import '../../utils/app_icons.dart';

/// HeroCard
///
/// A prominent card widget typically used at the top of a screen
/// to display a hero image, title, subtitle, and an optional badge.
/// It supports multiple images for a carousel-like display and optional actions.
///
/// Used in:
/// - `home_screen.dart`
/// - `variety_detail_page.dart`
/// - `diagnostic_details_page.dart`
/// - `stage_guidance_page.dart`
/// - `hhome_page.dart` (VisualCropExplorerPage)
///
class HeroCard extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final String? subtitle;
  final String? badgeText;
  final IconData? badgeIcon;
  final Widget? action;
  final double? height;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final bool showBorder;

  const HeroCard({
    super.key,
    required this.imageUrls,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.badgeIcon,
    this.action,
    this.height,
    this.borderRadius,
    this.gradientColors,
    this.badgeColor,
    this.badgeTextColor,
    this.titleFontSize,
    this.subtitleFontSize,
    this.showBorder = false,
  });

  // Convenience constructor for a single image
  HeroCard.single({
    super.key,
    required String imageUrl,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.badgeIcon,
    this.action,
    this.height,
    this.borderRadius,
    this.gradientColors,
    this.badgeColor,
    this.badgeTextColor,
    this.titleFontSize,
    this.subtitleFontSize,
    this.showBorder = false,
  }) : imageUrls = [imageUrl];

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final actualHeight = widget.height ?? 300.0;

    return SizedBox(
      height: actualHeight,
      child: ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          children: [
            // Image Slider
            PageView.builder(
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                    ),
                    if (widget.imageUrls[index].isNotEmpty)
                      Image.network(
                        widget.imageUrls[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primaryColor,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildErrorPlaceholder();
                        },
                      )
                    else
                      _buildErrorPlaceholder(),
                  ],
                );
              },
            ),

            // Overlay Gradient
            if (widget.title.isNotEmpty)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          widget.gradientColors ??
                          [
                            AppColors.transparent,
                            AppColors.primaryColor.withValues(alpha: 0.4),
                            AppColors.primaryColor,
                          ],
                    ),
                  ),
                ),
              ),

            // Text Content (Title/Subtitle)
            if (widget.title.isNotEmpty)
              Positioned(
                bottom: AppSizes.lg,
                left: AppSizes.md,
                right: AppSizes.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.badgeColor ??
                              AppColors.accentGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMax,
                          ),
                          border: widget.showBorder
                              ? Border.all(
                                  color:
                                      (widget.badgeTextColor ?? AppColors.white)
                                          .withValues(alpha: 0.3),
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.badgeIcon != null) ...[
                              Icon(
                                widget.badgeIcon,
                                color: widget.badgeTextColor ?? AppColors.white,
                                size: AppSizes.iconMd,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              widget.badgeText!,
                              style: TextStyle(
                                color: widget.badgeTextColor ?? AppColors.white,
                                fontSize: AppSizes.fontCaption,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.badgeText != null)
                      const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: widget.titleFontSize ?? AppSizes.fontHeading,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize:
                              widget.subtitleFontSize ?? AppSizes.fontBody,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (widget.action != null) ...[
                      const SizedBox(height: AppSizes.md),
                      widget.action!,
                    ],
                  ],
                ),
              ),

            // Image Counter (Only if multiple images)
            if (widget.imageUrls.length > 1)
              Positioned(
                bottom: AppSizes.md,
                right: AppSizes.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.fontCaption,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.imageNotSupported,
              color: AppColors.white70,
              size: AppSizes.xl * 2,
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              "Image details coming soon",
              style: TextStyle(
                color: AppColors.white70,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
