import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';

class VideoDto {
  final String name;
  final String image;
  final Object? duration;
  final String title;
  final String description;
  final Object? viewCount;
  final String publishDate;
  final String url;
  final String? pest;
  final String? disease;
  final String? nutrient;
  final String? lifecycle;

  VideoDto({
    required this.name,
    required this.image,
    required this.duration,
    required this.title,
    required this.description,
    this.viewCount,
    required this.publishDate,
    required this.url,
    this.pest,
    this.disease,
    this.nutrient,
    this.lifecycle,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) {
    return VideoDto(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      viewCount: json['view_count'],
      publishDate: json['publish_date'] ?? '',
      url: json['url'] ?? '',
      pest: json['pest'],
      disease: json['disease'],
      nutrient: json['nutrient'],
      lifecycle: json['lifecycle'],
    );
  }

  Video toEntity() {
    String formattedDuration = '00:00';
    if (duration is String) {
      formattedDuration = duration as String;
    } else if (duration is num) {
      final double durationSeconds = (duration as num).toDouble();
      final int minutes = (durationSeconds / 60).floor();
      final int seconds = (durationSeconds % 60).floor();
      formattedDuration =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Video(
      name: name,
      imageUrl: image,
      duration: formattedDuration,
      title: title,
      description: description,
      views: parseInt(viewCount)?.toString(),
      uploadTime: publishDate,
      youtubeVideoId: YoutubePlayer.convertUrlToId(url),
      url: url,
      pest: pest,
      disease: disease,
      nutrient: nutrient,
      lifecycle: lifecycle,
    );
  }
}
