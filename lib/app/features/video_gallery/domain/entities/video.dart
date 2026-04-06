/// Model class for video data
class Video {
  final String name;
  final String imageUrl;
  final String duration;
  final String title;
  final String description;
  final String? views;
  final String uploadTime;
  final String? youtubeVideoId;
  final String url;
  final String? pest;
  final String? disease;
  final String? nutrient;
  final String? lifecycle;

  const Video({
    this.name = '',
    required this.imageUrl,
    required this.duration,
    required this.title,
    required this.description,
    this.views,
    required this.uploadTime,
    this.youtubeVideoId,
    this.url = '',
    this.pest,
    this.disease,
    this.nutrient,
    this.lifecycle,
  });

  Video copyWith({
    String? name,
    String? imageUrl,
    String? duration,
    String? title,
    String? description,
    String? views,
    String? uploadTime,
    String? youtubeVideoId,
    String? url,
    String? pest,
    String? disease,
    String? nutrient,
    String? lifecycle,
  }) {
    return Video(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      description: description ?? this.description,
      views: views ?? this.views,
      uploadTime: uploadTime ?? this.uploadTime,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      url: url ?? this.url,
      pest: pest ?? this.pest,
      disease: disease ?? this.disease,
      nutrient: nutrient ?? this.nutrient,
      lifecycle: lifecycle ?? this.lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Video &&
          runtimeType == other.runtimeType &&
          youtubeVideoId == other.youtubeVideoId &&
          title == other.title;

  @override
  int get hashCode => youtubeVideoId.hashCode ^ title.hashCode;
}
