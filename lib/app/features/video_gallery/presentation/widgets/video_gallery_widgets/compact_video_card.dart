import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';

class CompactVideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback? onTap;

  const CompactVideoCard({super.key, required this.video, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, '/video-detail', arguments: video);
          },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: video.youtubeVideoId != null
                        ? Image.network(
                            'https://img.youtube.com/vi/${video.youtubeVideoId}/mqdefault.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: AppColors.grey300),
                          )
                        : (video.imageUrl.isNotEmpty
                              ? Image.network(
                                  video.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: AppColors.grey300),
                                )
                              : Container(color: AppColors.grey300)),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (video.duration.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
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
            const SizedBox(height: 8),
            Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2E1A),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
