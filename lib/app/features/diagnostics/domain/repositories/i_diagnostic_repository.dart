import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/diagnostic_category_model.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/nutrient.dart';

/// Repository interface for plant diagnostics, diseases, and nutrient deficiencies.
abstract class IDiagnosticRepository {
  /// Fetches available diagnostic categories.
  Future<Result<List<DiagnosticCategory>>> getDiagnostics();

  /// Fetches a list of all diseases.
  Future<Result<List<Disease>>> getDiseases();

  /// Fetches a list of diseases filtered by variety.
  Future<Result<List<Disease>>> getDiseaseList(String varietyId);

  /// Fetches detailed information for a specific disease.
  Future<Result<Disease?>> getDiseaseDetails(String name, String varietyId);

  /// Fetches a list of all nutrients.
  Future<Result<List<Nutrient>>> getNutrients();

  /// Fetches detailed information for a specific nutrient.
  Future<Result<Nutrient?>> getNutrientDetails(String name, String varietyId);

  /// Fetches a list of nutrient deficiencies filtered by variety.
  Future<Result<List<Nutrient>>> getNutrientDeficiencyList(String varietyId);

  /// Fetches detailed information for a specific nutrient deficiency.
  Future<Result<Nutrient?>> getNutrientDeficiencyDetails({
    required String varietyId,
    required String nutrient,
  });

  /// Uses AI to detect a disease from an image file path.
  Future<Result<Disease?>> detectDisease(String imagePath);
}
