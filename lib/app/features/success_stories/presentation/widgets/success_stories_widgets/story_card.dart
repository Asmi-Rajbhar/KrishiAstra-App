import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final StoryDetail story;

  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final isVideo = story.videoUrl.isNotEmpty;
    final category = story.headline.isNotEmpty
        ? story.headline.split(' ').last
        : 'Success Story';
    final description = story.contentParagraphs.isNotEmpty
        ? story.contentParagraphs.first
        : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with optional video badge
          Stack(
            children: [
              // Hero image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusMd),
                    topRight: Radius.circular(AppSizes.radiusMd),
                  ),
                  child: Image.network(
                    story.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.grey300,
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Video badge overlay
              if (isVideo)
                Positioned(
                  top: AppSizes.sm,
                  left: AppSizes.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMax),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle,
                          color: AppColors.accentGreen,
                          size: AppSizes.iconSm,
                        ),
                        SizedBox(width: AppSizes.xs),
                        Text(
                          'VIDEO',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category label
                Text(
                  category,
                  style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                // Title
                Text(
                  story.headline,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: AppSizes.fontBody,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                // Read full story button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.successStoryDetail,
                        arguments: story,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.readfullStoryButton,
                          style: const TextStyle(
                            fontSize: AppSizes.fontBody,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        const Icon(Icons.arrow_forward, size: AppSizes.iconSm),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
