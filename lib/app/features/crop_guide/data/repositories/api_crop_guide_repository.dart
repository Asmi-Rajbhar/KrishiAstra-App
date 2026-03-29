// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/crop_guide/domain/entities/variety_plantation_data.dart';
import 'package:krishiastra/app/features/crop_guide/domain/entities/environmental_stress.dart';
import 'package:krishiastra/app/features/crop_guide/domain/repositories/i_crop_guide_repository.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';

class ApiCropGuideRepository implements ICropGuideRepository {
  final Dio _dio;
  final IVideoRepository _videoRepository;

  ApiCropGuideRepository(this._dio, this._videoRepository);

  @override
  Future<Result<Map<String, dynamic>>> getClimaticConditions(
    String cropName,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.getClimaticRequirements,
        queryParameters: {'crop': cropName},
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['message'];
      if (rawData is List && rawData.isNotEmpty) {
        final first = rawData[0];
        if (first is Map<String, dynamic>) return Success(first);
      } else if (rawData is Map<String, dynamic>) {
        return Success(rawData);
      }
      return const Success({});
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<EnvironmentalStress>>> getEnvironmentalStress(
    String varietyId,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.getEnvironmentalStress,
        queryParameters: {'crop_variety': _normalizeVariety(varietyId)},
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['message'];
      final List<dynamic> listData = rawData is List
          ? rawData
          : (rawData is Map && rawData['data'] is List
                ? rawData['data'] as List
                : (data['data'] is List ? data['data'] as List : []));

      return Success(
        listData
            .whereType<Map<String, dynamic>>()
            .map((json) => EnvironmentalStress.fromJson(json))
            .toList(),
      );
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getPlantationMethod({
    required String varietyId,
    required String season,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getPlantationMethod,
        queryParameters: {
          'crop_variety': _normalizeVariety(varietyId),
          'crop_season': _normalizeSeason(season),
        },
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['data'] ?? data['message'];
      if (rawData is List && rawData.isNotEmpty) {
        final first = rawData[0];
        if (first is Map<String, dynamic>) return Success(first);
      } else if (rawData is Map<String, dynamic>) {
        return Success(rawData);
      }
      return const Success({});
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getPlantingGuide() async {
    return const Success({});
  }

  @override
  Future<Result<List<VarietyPlantationData>>> getPlantationSeasonData({
    required String varietyId,
    required String season,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getPlantationMethod,
        queryParameters: {
          'crop_variety': _normalizeVariety(varietyId),
          'crop_season': _normalizeSeason(season),
        },
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? raw = data['data'] ?? data['message'];
      final List<dynamic> rawData = raw is List ? raw : [];

      // Check if we even need videos before fetching them
      bool needsVideos = false;
      for (final Object? item in rawData) {
        if (item is Map<String, dynamic>) {
          final contentLibrary = item['content_library'] as List?;
          if (contentLibrary != null &&
              contentLibrary.any(
                (content) =>
                    content is Map && content['content_type'] == 'Video',
              )) {
            needsVideos = true;
            break;
          }
        }
      }

      Map<String, Video>? videoMap;
      if (needsVideos) {
        final videosResult = await _videoRepository.getVideos();
        if (videosResult.isSuccess) {
          videoMap = {for (var v in videosResult.data!) v.name: v};
        }
      }

      final list = rawData.whereType<Map<String, dynamic>>().map((json) {
        final seasons = (json['plantation_season'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(
              (s) => SeasonInfo(
                season: s['season']?.toString() ?? '',
                month: s['month']?.toString() ?? '',
              ),
            )
            .toList();

        final spacing = (json['seed_rate_and_spacing'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(
              (s) => SeedRateSpacingInfo(
                seedRate: s['seed_rate']?.toString() ?? '',
                spacing: s['spacing']?.toString() ?? '',
                depth: s['depth']?.toString() ?? '',
              ),
            )
            .toList();

        final videos = (json['content_library'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .where((item) => item['content_type'] == 'Video')
            .map((v) {
              final linkName = v['link_name']?.toString() ?? '';
              final Video? resolvedVideo = videoMap?[linkName];
              return PlantationVideo(
                title: resolvedVideo?.title ?? linkName,
                url: resolvedVideo?.url ?? '',
                duration: resolvedVideo?.duration ?? '',
                description: resolvedVideo?.description,
              );
            })
            .toList();

        final soilPrep = (json['soil_preparation'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(
              (s) => SoilPreparationInfo(
                deepPloughing: s['deep_ploughing']?.toString() ?? '',
                harrowing: s['harrowing']?.toString() ?? '',
                manureApplication: s['manure_application']?.toString() ?? '',
              ),
            )
            .toList();

        return VarietyPlantationData(
          name: json['name']?.toString() ?? '',
          cropVariety: json['crop_variety']?.toString() ?? '',
          plantationSeasons: seasons,
          seedRateAndSpacing: spacing,
          videos: videos,
          soilPreparation: soilPrep,
        );
      }).toList();
      return Success(list);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  String _normalizeVariety(String name) {
    return name.replaceAll('Co ', '').trim();
  }

  String _normalizeSeason(String season) {
    return season.toLowerCase().trim();
  }
}
