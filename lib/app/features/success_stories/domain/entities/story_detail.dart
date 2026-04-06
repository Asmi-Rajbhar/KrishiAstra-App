/// Model class for success story details
class StoryDetail {
  final String videoUrl;
  final String thumbnailUrl;
  final String authorName;
  final String authorImage;
  final String location;
  final String headline;
  final String yieldIncrease;
  final String costSaved;
  final List<String> contentParagraphs;
  final String highlightTitle;
  final String highlightText;
  final String description;
  final String keyTakeaway;
  final String pest;
  final String disease;
  final String nutrient;

  const StoryDetail({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.authorName,
    required this.authorImage,
    required this.location,
    required this.headline,
    required this.yieldIncrease,
    required this.costSaved,
    required this.contentParagraphs,
    required this.highlightTitle,
    required this.highlightText,
    this.description = '',
    this.keyTakeaway = '',
    this.pest = '',
    this.disease = '',
    this.nutrient = '',
  });

  StoryDetail copyWith({
    String? videoUrl,
    String? thumbnailUrl,
    String? authorName,
    String? authorImage,
    String? location,
    String? headline,
    String? yieldIncrease,
    String? costSaved,
    List<String>? contentParagraphs,
    String? highlightTitle,
    String? highlightText,
    String? description,
    String? keyTakeaway,
    String? pest,
    String? disease,
    String? nutrient,
  }) {
    return StoryDetail(
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      location: location ?? this.location,
      headline: headline ?? this.headline,
      yieldIncrease: yieldIncrease ?? this.yieldIncrease,
      costSaved: costSaved ?? this.costSaved,
      contentParagraphs: contentParagraphs ?? this.contentParagraphs,
      highlightTitle: highlightTitle ?? this.highlightTitle,
      highlightText: highlightText ?? this.highlightText,
      description: description ?? this.description,
      keyTakeaway: keyTakeaway ?? this.keyTakeaway,
      pest: pest ?? this.pest,
      disease: disease ?? this.disease,
      nutrient: nutrient ?? this.nutrient,
    );
  }
}
