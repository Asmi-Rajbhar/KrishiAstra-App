// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/checklist_item.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/lifecycle_stage.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/crop_lifecycle_stage.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:flutter/foundation.dart';

class ApiLifecycleRepository implements ILifecycleRepository {
  final Dio _dio;
  final ICropRepository _cropRepository;

  ApiLifecycleRepository(this._dio, this._cropRepository);

  @override
  Future<Result<List<ChecklistItem>>> getChecklist(String stageNumber) async {
    return const Success([]);
  }

  @override
  Future<Result<List<LifecycleStage>>> getLifecycleStages() async {
    return const Success([]);
  }

  @override
  Future<Result<List<CropLifecycleStage>>> getCropLifecycle({
    required String variety,
    required String season,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropLifecycle,
        queryParameters: {
          'crop_variety': _normalizeVariety(variety),
          'crop_season': _normalizeSeason(season),
        },
      );

      final Object? rootValue = response.data;
      Object? rawData;
      if (rootValue is Map) {
        final Object? message = rootValue['message'];
        final Object? dataField = rootValue['data'];

        if (message is Map) {
          rawData =
              message['stages'] ??
              message['data'] ??
              message['lifecycle'] ??
              message['list'] ??
              message;
        } else if (message is List) {
          rawData = message;
        } else if (dataField is Map) {
          rawData =
              dataField['stages'] ??
              dataField['data'] ??
              dataField['lifecycle'] ??
              dataField;
        } else if (dataField is List) {
          rawData = dataField;
        }
      } else if (rootValue is List) {
        rawData = rootValue;
      }

      List<dynamic> dataList = rawData is List ? rawData : [];
      final List<CropLifecycleStage> stages = [];
      for (var entry in dataList) {
        if (entry is Map) {
          try {
            final stage = CropLifecycleStage.fromJson(
              Map<String, dynamic>.from(entry),
            );
            if (stage.stageName.isNotEmpty) {
              stages.add(stage);
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing lifecycle stage: $e');
          }
        }
      }
      return Success(stages);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<CropLifecycleStage>>> getCropLifecycleStages(
    String cropName,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropLifecycleStages,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final List<dynamic> dataList =
          (data['data'] as Map?)?['crop_lifecycle'] as List? ?? [];
      final List<CropLifecycleStage> stages = [];
      for (var entry in dataList) {
        if (entry is Map) {
          stages.add(
            CropLifecycleStage.fromJson(Map<String, dynamic>.from(entry)),
          );
        }
      }
      return Success(stages);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<CropVariety>>> getVarieties(String cropName) {
    return _cropRepository.getVarieties(cropName);
  }

  @override
  Future<Result<List<String>>> getAvailableSeasons(String varietyName) {
    return _cropRepository.getAvailableSeasons(varietyName);
  }

  String _normalizeVariety(String name) {
    return name.replaceAll('Co ', '').trim();
  }

  String _normalizeSeason(String season) {
    return season.toLowerCase().trim();
  }
}
