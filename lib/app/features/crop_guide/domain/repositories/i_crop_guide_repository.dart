import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/crop_guide/domain/entities/environmental_stress.dart';
import 'package:krishiastra/app/features/crop_guide/domain/entities/variety_plantation_data.dart';

/// Repository interface for crop guide related operations.
/// This includes climatic conditions, plantation methods, and environmental stress.
abstract class ICropGuideRepository {
  /// Fetches climatic conditions for a specific crop.
  Future<Result<Map<String, dynamic>>> getClimaticConditions(String cropName);

  /// Fetches plantation method details for a specific variety and season.
  Future<Result<Map<String, dynamic>>> getPlantationMethod({
    required String varietyId,
    required String season,
  });

  /// Fetches the general planting guide.
  Future<Result<Map<String, dynamic>>> getPlantingGuide();

  /// Fetches plantation season data (stages/activities) for a variety and season.
  Future<Result<List<VarietyPlantationData>>> getPlantationSeasonData({
    required String varietyId,
    required String season,
  });

  /// Fetches environmental stress information for a crop variety.
  Future<Result<List<EnvironmentalStress>>> getEnvironmentalStress(
    String varietyId,
  );
}
