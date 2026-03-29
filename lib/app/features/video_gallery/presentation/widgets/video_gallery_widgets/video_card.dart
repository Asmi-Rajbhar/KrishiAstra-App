import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with AutomaticKeepAliveClientMixin {
  YoutubePlayerController? _youtubeController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.video.youtubeVideoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.video.youtubeVideoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: false,
          showLiveFullscreenButton: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/video-detail', arguments: widget.video);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    widget.video.youtubeVideoId != null &&
                        _youtubeController != null
                    ? YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.primaryColor,
                        bottomActions: [
                          const CurrentPosition(),
                          const ProgressBar(isExpanded: true),
                          const RemainingDuration(),
                          const FullScreenButton(),
                        ],
                      )
                    : Image.network(
                        widget.video.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: AppColors.grey300),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: AppSizes.fontTitle,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate800,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const Icon(
                      AppIcons.moreVert,
                      color: AppColors.grey400,
                      size: AppSizes.iconMd,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xxs),
                Text(
                  widget.video.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.fontBody,
                    color: AppColors.slate500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    if (widget.video.views != null &&
                        widget.video.views!.isNotEmpty) ...[
                      const Icon(
                        AppIcons.visibility,
                        color: AppColors.slate500,
                        size: AppSizes.iconSm,
                      ),
                      const SizedBox(width: AppSizes.xxs),
                      Text(
                        '${widget.video.views} VIEWS',
                        style: const TextStyle(
                          fontSize: AppSizes.fontCaption,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                    if (widget.video.views != null &&
                        widget.video.views!.isNotEmpty &&
                        widget.video.uploadTime.isNotEmpty)
                      const SizedBox(width: AppSizes.md),
                    if (widget.video.uploadTime.isNotEmpty) ...[
                      const Icon(
                        AppIcons.calendarToday,
                        color: AppColors.slate500,
                        size: AppSizes.iconSm,
                      ),
                      const SizedBox(width: AppSizes.xxs),
                      Text(
                        widget.video.uploadTime.toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppSizes.fontCaption,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
