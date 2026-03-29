// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/diagnostic_category_model.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/nutrient.dart';
import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/features/diagnostics/data/ai_disease_database.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';
import 'package:krishiastra/app/features/diagnostics/data/mappers/disease_mapper.dart';
import 'package:krishiastra/app/features/video_gallery/data/models/video_dto.dart';
import 'package:flutter/foundation.dart';

class ApiDiagnosticRepository
    implements IDiagnosticRepository, IVideoRepository {
  final Dio _dio;

  ApiDiagnosticRepository(this._dio);

  @override
  Future<Result<List<Video>>> getVideos({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(ApiConstants.getVideoList);

      final Object? rootValue = response.data;
      Object? rawData;
      if (rootValue is Map) {
        final Object? message = rootValue['message'];
        final Object? dataField = rootValue['data'];

        if (message is List) {
          rawData = message;
        } else if (message is Map) {
          rawData =
              message['videos'] ??
              message['data'] ??
              message['list'] ??
              message;
        } else if (dataField is List) {
          rawData = dataField;
        } else if (dataField is Map) {
          rawData = dataField['videos'] ?? dataField['data'] ?? dataField;
        }
      } else if (rootValue is List) {
        rawData = rootValue;
      }

      final List<dynamic> videosList = rawData is List
          ? rawData
          : (rawData is Map && rawData['videos'] is List
                ? rawData['videos'] as List
                : []);

      final list = videosList
          .whereType<Map<String, dynamic>>()
          .map((json) => VideoDto.fromJson(json).toEntity())
          .toList();

      return Success(list.skip(offset).take(limit).toList());
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<List<DiagnosticCategory>>> getDiagnostics() async {
    return const Success([
      DiagnosticCategory(
        type: DiagnosticType.pest,
        icon: AppIcons.bugReport,
        title: 'pestIdentification',
        description: 'pestIdentificationDesc',
        footer: 'pestIdentificationFooter',
      ),
      DiagnosticCategory(
        type: DiagnosticType.disease,
        icon: AppIcons.coronavirus,
        title: 'diseaseSymptomChecker',
        description: 'diseaseSymptomCheckerDesc',
        footer: 'diseaseSymptomCheckerFooter',
      ),
      DiagnosticCategory(
        type: DiagnosticType.nutrient,
        icon: AppIcons.science,
        title: 'nutrientDeficiency',
        description: 'nutrientDeficiencyDesc',
        footer: 'nutrientDeficiencyFooter',
      ),
      DiagnosticCategory(
        type: DiagnosticType.environment,
        icon: AppIcons.waterDrop,
        title: 'environmentalStress',
        description: 'environmentalStressDesc',
        footer: 'environmentalStressFooter',
      ),
    ]);
  }

  @override
  Future<Result<List<Disease>>> getDiseases() async {
    try {
      final response = await _dio.get(ApiConstants.getDiseaseMaster);
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Map<String, dynamic> masterData =
          (data['message'] as Map?)?['data'] as Map<String, dynamic>? ?? {};

      final List<Disease> diseases = [];

      for (var varietyEntry in masterData.entries) {
        final varietyData = varietyEntry.value as Map<String, dynamic>?;
        if (varietyData == null) continue;

        final cropDiseases = varietyData['crop_diseases'] as List?;
        if (cropDiseases == null) continue;

        for (var diseaseJson in cropDiseases) {
          if (diseaseJson is Map<String, dynamic>) {
            diseases.add(DiseaseMapper.mapToEntity(diseaseJson));
          }
        }
      }

      return Success(diseases);
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<List<Disease>>> getDiseaseList(String varietyId) async {
    try {
      final response = await _dio.get(
        ApiConstants.getDiseasesList,
        queryParameters: {'crop_variety': _normalizeVariety(varietyId)},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['data'] ?? data['message'];
      final List<dynamic> dataList = rawData is List ? rawData : [];

      final List<Disease> diseases = [];

      for (var diseaseJson in dataList) {
        if (diseaseJson is Map<String, dynamic>) {
          diseases.add(DiseaseMapper.mapToEntity(diseaseJson));
        }
      }

      return Success(diseases);
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<Disease?>> getDiseaseDetails(
    String name,
    String varietyId,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.getDiseaseDetails,
        queryParameters: {
          'crop_variety': _normalizeVariety(varietyId),
          'disease': name,
        },
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['data'] ?? data['message'];

      if (rawData == null) return const Success(null);

      if (rawData is Map<String, dynamic>) {
        return Success(DiseaseMapper.mapToEntity(rawData));
      } else if (rawData is List && rawData.isNotEmpty) {
        final firstItem = rawData.first;
        if (firstItem is Map<String, dynamic>) {
          return Success(DiseaseMapper.mapToEntity(firstItem));
        }
      }

      return const Success(null);
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<List<Nutrient>>> getNutrients() async {
    try {
      final response = await _dio.get(ApiConstants.getNutrientList);
      final Map<String, dynamic> resData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic> data =
          (resData['data'] as Map?)?['nutrient_deficiency_master']
              as Map<String, dynamic>? ??
          {};

      final Map<String, Nutrient> uniqueNutrients = {};

      for (var entry in data.entries) {
        try {
          final varietyData = entry.value as Map<String, dynamic>;
          final nutrientArray = varietyData['nutrient_deficiency'] as List?;

          if (nutrientArray != null) {
            for (var nutrientJson in nutrientArray) {
              if (nutrientJson is Map<String, dynamic>) {
                final json = nutrientJson;
                final nutrientName = json['name']?.toString() ?? '';

                if (nutrientName.isNotEmpty &&
                    !uniqueNutrients.containsKey(nutrientName)) {
                  final nutrient = Nutrient(
                    nutrient: nutrientName,
                    description: json['description']?.toString() ?? '',
                    image: json['image']?.toString() ?? '',
                    symptoms: json['symptoms']?.toString(),
                    causeOfDeficiency: json['cause_of_deficiency']?.toString(),
                    video:
                        json['video'] != null &&
                            json['video'] is Map<String, dynamic>
                        ? NutrientVideo.fromJson(
                            json['video'] as Map<String, dynamic>,
                          )
                        : null,
                    remedies:
                        json['remedies'] != null && json['remedies'] is List
                        ? (json['remedies'] as List)
                              .whereType<Map<String, dynamic>>()
                              .map((e) => NutrientRemedy.fromJson(e))
                              .toList()
                        : null,
                  );

                  uniqueNutrients[nutrientName] = nutrient;
                }
              }
            }
          }
        } catch (e) {
          if (kDebugMode) debugPrint('Error parsing variety ${entry.key}: $e');
        }
      }

      return Success(uniqueNutrients.values.toList());
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<List<Nutrient>>> getNutrientDeficiencyList(
    String varietyId,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.getNutrientDeficiencyList,
        queryParameters: {'crop_variety': _normalizeVariety(varietyId)},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final List<dynamic> listData = data['data'] is List
          ? data['data'] as List
          : [];

      final List<Nutrient> nutrients = [];
      for (var json in listData) {
        if (json is Map<String, dynamic>) {
          final nutrient = Nutrient.fromJson(json);
          String imageUrl = nutrient.image;
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
            imageUrl = '${ApiConstants.baseUrl}$imageUrl';
          }
          nutrients.add(nutrient.copyWith(image: imageUrl));
        }
      }
      return Success(nutrients);
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<Nutrient?>> getNutrientDetails(
    String name,
    String varietyId,
  ) async {
    return getNutrientDeficiencyDetails(varietyId: varietyId, nutrient: name);
  }

  @override
  Future<Result<Nutrient?>> getNutrientDeficiencyDetails({
    required String varietyId,
    required String nutrient,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getNutrientDeficiencyDetails,
        queryParameters: {
          'crop_variety': _normalizeVariety(varietyId),
          'nutrient': nutrient,
        },
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['data'] ?? data['message'];
      if (rawData == null) return const Success(null);

      Map<String, dynamic>? json;
      if (rawData is Map<String, dynamic>) {
        json = rawData;
      } else if (rawData is List && rawData.isNotEmpty) {
        final firstItem = rawData.first;
        if (firstItem is Map<String, dynamic>) {
          json = firstItem;
        }
      }

      if (json != null) {
        final nutrientObj = Nutrient.fromJson(json);
        String imageUrl = nutrientObj.image;
        if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
          imageUrl = '${ApiConstants.baseUrl}$imageUrl';
        }
        return Success(nutrientObj.copyWith(image: imageUrl));
      }
      return const Success(null);
    } catch (e) {
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  @override
  Future<Result<Disease?>> detectDisease(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        ApiConstants.aiModelBaseUrl,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 90),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        if (data['disease_name'] != null) {
          final diseaseName = data['disease_name'] as String;
          final disease = AiDiseaseDatabase.getDiseaseByAiName(diseaseName);

          if (disease != null) {
            return Success(disease);
          } else {
            return Error(
              ServerFailure(
                message:
                    'l10n:diseaseDetectedButNotFound|$diseaseName',
              ),
            );
          }
        }
      }
      return const Success(null);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.receiveTimeout) {
          return const Error(
            ServerFailure(
              message:
                  'l10n:aiModelTimeout',
            ),
          );
        }
      }
      return const Error(ServerFailure(message: 'l10n:somethingWentWrong'));
    }
  }

  String _normalizeVariety(String name) {
    return name.replaceAll('Co ', '').trim();
  }
}
