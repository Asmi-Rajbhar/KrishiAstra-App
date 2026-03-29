import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_risk_and_care.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_requirement.dart';

/// Repository interface for crop and variety related operations.
abstract class ICropRepository {
  /// Fetches a list of varieties for a given crop.
  Future<Result<List<CropVariety>>> getVarieties(String cropName);

  /// Fetches comprehensive information for a crop.
  Future<Result<CropInfo>> getCropInfo(String cropName);

  /// Fetches basic details for a crop.
  Future<Result<CropBasicDetails>> getCropBasicDetails(String cropName);

  /// Fetches risk and care information for a crop.
  Future<Result<CropRiskAndCare>> getRiskAndCare(String cropName);

  /// Fetches cultivation requirements for a crop.
  Future<Result<CropRequirement>> getCropRequirements(String cropName);

  /// Fetches detailed information for a specific crop variety and season.
  Future<Result<CropVarietyDetail?>> getCropVarietyDetails(
    String varietyName, {
    String? season,
  });

  /// Fetches a list of available seasons for a specific variety.
  Future<Result<List<String>>> getAvailableSeasons(String varietyName);

  /// Fetches a list of available seasons for a specific crop.
  Future<Result<List<String>>> getAvailableCropSeasons(String name);
}
