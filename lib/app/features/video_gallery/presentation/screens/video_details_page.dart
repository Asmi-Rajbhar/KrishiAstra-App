import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/bloc/video_gallery_bloc.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailsPage extends StatefulWidget {
  final Video video;

  const VideoDetailsPage({super.key, required this.video});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeVideoId ?? '',
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // Handle state changes if needed
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primaryColor,
        onReady: () {
          _isPlayerReady = true;
        },
        bottomActions: [
          const CurrentPosition(),
          const ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: AppColors.primaryColor,
              handleColor: AppColors.primaryColor,
            ),
          ),
          const RemainingDuration(),
          const FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Player section
                player,

                // Details section
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.lg,
                    ),
                    children: [
                      // Title
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: AppSizes.fontTitle,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),

                      // Metadata Row
                      Row(
                        children: [
                          if (widget.video.views != null) ...[
                            Text(
                              l10n.viewsCount(widget.video.views.toString()),
                              style: const TextStyle(
                                color: AppColors.grey600,
                                fontSize: AppSizes.fontCaption,
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.grey400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                          ],
                          Text(
                            widget.video.uploadTime,
                            style: const TextStyle(
                              color: AppColors.grey600,
                              fontSize: AppSizes.fontCaption,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Author Row
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.eco,
                                color: AppColors.white,
                                size: AppSizes.iconMd,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.academyName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.fontBody,
                                  ),
                                ),
                                Text(
                                  l10n.academySubtitle,
                                  style: const TextStyle(
                                    color: AppColors.grey600,
                                    fontSize: AppSizes.fontCaption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryColor
                                  .withValues(alpha: 0.1),
                              foregroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMax,
                                ),
                              ),
                            ),
                            child: Text(l10n.subscribe),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Description
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDescriptionExpanded = !_isDescriptionExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.md),
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.video.description,
                                maxLines: _isDescriptionExpanded ? null : 3,
                                overflow: _isDescriptionExpanded
                                    ? null
                                    : TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: AppSizes.fontBody,
                                  color: AppColors.grey600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                _isDescriptionExpanded
                                    ? l10n.showLess
                                    : l10n.showMore,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontCaption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),

                      // Up Next / Related Videos
                      Text(
                        l10n.upNext,
                        style: const TextStyle(
                          fontSize: AppSizes.fontHeading,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Related Videos List
                      BlocBuilder<VideoGalleryBloc, VideoGalleryState>(
                        builder: (context, state) {
                          if (state is VideoGalleryLoaded) {
                            final relatedVideos = state.videos
                                .where(
                                  (v) =>
                                      v.youtubeVideoId !=
                                      widget.video.youtubeVideoId,
                                )
                                .take(6)
                                .toList();

                            return Column(
                              children: relatedVideos
                                  .map(
                                    (v) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSizes.md,
                                      ),
                                      child: _buildRelatedVideoItem(v, l10n),
                                    ),
                                  )
                                  .toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRelatedVideoItem(Video video, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/video-detail',
          arguments: video,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: SizedBox(
                  width: 140,
                  height: 80,
                  child: Image.network(
                    'https://img.youtube.com/vi/${video.youtubeVideoId}/mqdefault.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.grey300),
                  ),
                ),
              ),
              Positioned(
                bottom: AppSizes.xxs,
                right: AppSizes.xxs,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video.duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.sm),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.academyName,
                  style: const TextStyle(
                    fontSize: AppSizes.fontCaption,
                    color: AppColors.grey600,
                  ),
                ),
                Text(
                  '${l10n.viewsCount(video.views?.toString() ?? "0")} • ${video.uploadTime}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey600,
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
