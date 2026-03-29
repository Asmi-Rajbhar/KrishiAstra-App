import 'package:equatable/equatable.dart';

class SeasonInfo extends Equatable {
  final String season;
  final String month;

  const SeasonInfo({required this.season, required this.month});

  @override
  List<Object?> get props => [season, month];
}

class SoilPreparationInfo extends Equatable {
  final String deepPloughing;
  final String harrowing;
  final String manureApplication;

  const SoilPreparationInfo({
    required this.deepPloughing,
    required this.harrowing,
    required this.manureApplication,
  });

  @override
  List<Object?> get props => [deepPloughing, harrowing, manureApplication];
}

class SeedRateSpacingInfo extends Equatable {
  final String seedRate;
  final String spacing;
  final String depth;

  const SeedRateSpacingInfo({
    required this.seedRate,
    required this.spacing,
    required this.depth,
  });

  @override
  List<Object?> get props => [seedRate, spacing, depth];
}

class PlantationVideo extends Equatable {
  final String title;
  final String url;
  final String duration;
  final String? description;

  const PlantationVideo({
    required this.title,
    required this.url,
    required this.duration,
    this.description,
  });

  @override
  List<Object?> get props => [title, url, duration, description];
}

class VarietyPlantationData extends Equatable {
  final String name;
  final String cropVariety;
  final List<SeasonInfo> plantationSeasons;
  final List<SeedRateSpacingInfo> seedRateAndSpacing;
  final List<PlantationVideo> videos;
  final List<SoilPreparationInfo> soilPreparation;

  const VarietyPlantationData({
    required this.name,
    required this.cropVariety,
    required this.plantationSeasons,
    required this.seedRateAndSpacing,
    required this.videos,
    required this.soilPreparation,
  });

  @override
  List<Object?> get props => [
    name,
    cropVariety,
    plantationSeasons,
    seedRateAndSpacing,
    videos,
    soilPreparation,
  ];
}
