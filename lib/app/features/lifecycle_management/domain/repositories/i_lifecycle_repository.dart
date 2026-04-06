import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/lifecycle_stage.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/checklist_item.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/crop_lifecycle_stage.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';

/// Repository interface for crop lifecycle management.
abstract class ILifecycleRepository {
  /// Fetches global lifecycle stages.
  Future<Result<List<LifecycleStage>>> getLifecycleStages();

  /// Fetches the checklist for a specific stage number.
  Future<Result<List<ChecklistItem>>> getChecklist(String stageNumber);

  /// Fetches the lifecycle information (stages and activities) for a specific variety and season.
  Future<Result<List<CropLifecycleStage>>> getCropLifecycle({
    required String variety,
    required String season,
  });

  /// Fetches global lifecycle stages for a specific crop.
  Future<Result<List<CropLifecycleStage>>> getCropLifecycleStages(
    String cropName,
  );

  /// Fetches a list of varieties for a given crop.
  Future<Result<List<CropVariety>>> getVarieties(String cropName);

  /// Fetches a list of available seasons for a specific variety.
  Future<Result<List<String>>> getAvailableSeasons(String variety);
}
