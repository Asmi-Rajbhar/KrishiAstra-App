import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/success_stories/presentation/bloc/success_stories_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/video_card.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage({super.key, required this.story});
  final StoryDetail story;

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late StoryDetail _currentStory;

  @override
  void initState() {
    super.initState();
    _currentStory = widget.story;
    context.read<SuccessStoriesBloc>().add(
      FetchStoryDetail(_currentStory.headline),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SuccessStoriesBloc, SuccessStoriesState>(
      builder: (context, state) {
        if (state is StoryDetailLoaded) {
          _currentStory = state.story;
        }

        final String? youtubeId = YoutubePlayer.convertUrlToId(
          _currentStory.videoUrl,
        );

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              context.read<SuccessStoriesBloc>().add(const ReturnToList());
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: CustomAppBar(
              leadingIcon: AppIcons.arrowBackIosNew,
              titleText: l10n.successStory,
              onLeadingPressed: () {
                context.read<SuccessStoriesBloc>().add(const ReturnToList());
                Navigator.of(context).pop();
              },
            ),
            body: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    VideoCard(
                      video: Video(
                        title: _currentStory.headline,
                        description: _currentStory.description,
                        youtubeVideoId: youtubeId,
                        imageUrl: _currentStory.thumbnailUrl,
                        uploadTime: '',
                        views: '',
                        duration: '',
                      ),
                    ),
                    _buildAuthorProfile(),
                    _buildStoryContent(l10n),
                    const SizedBox(height: AppSizes.lg),
                  ],
                ),
                if (state is SuccessStoriesLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentGreen,
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: const BottomNav(activeIndex: 2),
          ),
        );
      },
    );
  }

  Widget _buildAuthorProfile() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: BaseCard(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            // Profile image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentGreen.withValues(alpha: 0.2),
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(_currentStory.authorImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentStory.authorName,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxs),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.accentGreen,
                        size: AppSizes.iconSm,
                      ),
                      const SizedBox(width: AppSizes.xxs),
                      Text(
                        _currentStory.location,
                        style: const TextStyle(
                          color: AppColors.grey600,
                          fontSize: AppSizes.fontBody,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(AppLocalizations l10n) {
    return SectionCard(
      title: l10n.farmersStory,
      icon: const Icon(AppIcons.book, color: AppColors.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentStory.headline,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppSizes.fontHeading,
              fontWeight: FontWeight.bold,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: AppSizes.sm),
          if (_currentStory.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: Text(
                _currentStory.description,
                style: const TextStyle(
                  color: AppColors.grey600,
                  fontSize: AppSizes.fontBody,
                  height: 1.6,
                ),
              ),
            ),
          ..._currentStory.contentParagraphs.map((paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: Text(
                paragraph,
                style: const TextStyle(
                  color: AppColors.grey600,
                  fontSize: AppSizes.fontBody,
                  height: 1.6,
                ),
              ),
            );
          }),
          const SizedBox(height: AppSizes.sm),
          // Highlight box
          if (_currentStory.highlightText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentStory.highlightTitle,
                    style: const TextStyle(
                      color: AppColors.accentGreen,
                      fontSize: AppSizes.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    _currentStory.highlightText,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.fontBody,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
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
