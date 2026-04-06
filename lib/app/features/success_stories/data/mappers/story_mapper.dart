import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';

class StoryMapper {
  static StoryDetail mapToEntity(Map<String, dynamic> json) {
    final videoRaw = json['video'];
    Map<String, dynamic>? video;
    if (videoRaw is Map<String, dynamic>) {
      video = videoRaw;
    }
    final String videoUrl = (video?['url'] ?? json['video_url'] ?? '')
        .toString();

    String? thumbnailUrl = json['images'] ?? json['image'] ?? json['thumbnail'];
    if (thumbnailUrl is List && (thumbnailUrl as List).isNotEmpty) {
      thumbnailUrl = (thumbnailUrl as List).first.toString();
    } else {
      thumbnailUrl = thumbnailUrl?.toString();
    }

    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      if (!thumbnailUrl.startsWith('http')) {
        thumbnailUrl = '${ApiConstants.baseUrl}$thumbnailUrl';
      }
    } else if (videoUrl.isNotEmpty) {
      final videoId = _extractYoutubeId(videoUrl);
      if (videoId != null) {
        thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
      }
    }

    return StoryDetail(
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl ?? '',
      authorName: json['author'] ?? 'Unknown Author',
      authorImage:
          json['author_image'] != null &&
              json['author_image'].toString().isNotEmpty
          ? (json['author_image'].toString().startsWith('http')
                ? json['author_image'].toString()
                : '${ApiConstants.baseUrl}${json['author_image']}')
          : '',
      location: json['location'] ?? '',
      headline: json['title'] ?? 'Success Story',
      yieldIncrease: '',
      costSaved: '',
      contentParagraphs: json['title_description'] != null
          ? [json['title_description']]
          : (json['content'] is List
                ? List<String>.from(json['content'])
                : (json['content'] != null
                      ? [json['content'].toString()]
                      : [])),
      highlightTitle: 'Key Takeaway',
      highlightText: json['key_takeaway'] ?? '',
      description: json['description'] ?? json['title_description'] ?? '',
      keyTakeaway: json['key_takeaway'] ?? '',
      pest: json['pest'] ?? '',
      disease: json['disease'] ?? '',
      nutrient: json['nutrient'] ?? '',
    );
  }

  static String? _extractYoutubeId(String url) {
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('v=')) {
      return url.split('v=').last.split('&').first;
    } else if (url.contains('embed/')) {
      return url.split('embed/').last.split('?').first;
    }
    return null;
  }
}
