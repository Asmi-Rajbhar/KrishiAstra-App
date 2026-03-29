import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/utils/app_images.dart';

class MediaItem extends StatelessWidget {
  final bool isVideo;
  final String? duration;
  final int? photoCount;
  final String title;

  const MediaItem({
    super.key,
    required this.isVideo,
    this.duration,
    this.photoCount,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                image: const DecorationImage(
                  image: NetworkImage(AppImages.stageGuidanceHero),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Play button overlay for videos
            if (isVideo)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.xs),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.2),
                          blurRadius: AppSizes.sm,
                        ),
                      ],
                    ),
                    child: const Icon(
                      AppIcons.playArrow,
                      color: AppColors.primaryColor,
                      size: AppSizes.iconMd,
                    ),
                  ),
                ),
              ),
            // Duration badge for videos
            if (isVideo && duration != null)
              Positioned(
                bottom: AppSizes.xs,
                right: AppSizes.xs,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    duration!,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.fontCaption,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        // Title
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: AppSizes.fontBody,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
