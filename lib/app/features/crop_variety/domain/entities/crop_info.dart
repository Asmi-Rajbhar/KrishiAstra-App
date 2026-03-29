class CropInfo {
  final String name;
  final String cropName;
  final String scientificName;
  final String cropDescription;
  final String imageUrl;
  final String duration;
  final String season;
  final String yieldRange;
  final String soilType;
  final String waterRequirement;
  final String potentialIncome;
  final List<String> risks;
  final String fertilizerRequirement;
  final String laborIntensity;
  // final List<CropLifecycleStage> lifecycleStages; // Consider adding this if we have data

  CropInfo({
    required this.name,
    required this.cropName,
    required this.scientificName,
    required this.cropDescription,
    required this.imageUrl,
    this.duration = '',
    this.season = '',
    this.yieldRange = '',
    this.soilType = '',
    this.waterRequirement = '',
    this.potentialIncome = '',
    this.risks = const [],
    this.fertilizerRequirement = '',
    this.laborIntensity = '',
    //  this.lifecycleStages = const [],
  });

  factory CropInfo.fromMap(Map<String, dynamic> map) {
    return CropInfo(
      name: map['name'] ?? '',
      cropName: map['cropName'] ?? '',
      scientificName: map['scientificName'] ?? '',
      cropDescription: map['cropDescription'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      duration: map['duration'] ?? '',
      season: map['season'] ?? '',
      yieldRange: map['yieldRange'] ?? '',
      soilType: map['soilType'] ?? '',
      waterRequirement: map['waterRequirement'] ?? '',
      potentialIncome: map['potentialIncome'] ?? '',
      risks:
          (map['risks'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      fertilizerRequirement: map['fertilizerRequirement'] ?? '',
      laborIntensity: map['laborIntensity'] ?? '',
    );
  }
}
