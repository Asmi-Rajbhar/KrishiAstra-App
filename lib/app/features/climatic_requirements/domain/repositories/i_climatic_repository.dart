import 'package:krishiastra/app/features/climatic_requirements/domain/entities/climatic_model.dart';
import 'package:krishiastra/app/core/utils/result.dart';

/// Abstract interface class for the Climatic Repository.
/// This defines the blueprint for fetching climatic data without being tied to a specific data source.
abstract class IClimaticRepository {
  /// Fetches the climatic conditions for a crop.
  /// Returns a [ClimaticRequirement] entity wrapped in a [Result].
  Future<Result<ClimaticRequirement>> getClimaticConditions({
    String? crop,
    String? land,
  });
}
