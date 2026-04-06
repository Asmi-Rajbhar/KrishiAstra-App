// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_risk_and_care.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_requirement.dart';
import 'package:krishiastra/app/features/crop_variety/data/models/crop_basic_details_model.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';
import 'package:krishiastra/app/features/crop_variety/data/models/crop_variety_model.dart';
import 'package:krishiastra/app/features/crop_variety/data/models/crop_variety_detail_model.dart';

/// Concrete implementation of [ICropRepository] using Dio for network requests.
/// This repository handles core crop and variety information.
class ApiCropRepository implements ICropRepository {
  final Dio _dio;

  ApiCropRepository(this._dio);

  @override
  Future<Result<List<CropVariety>>> getVarieties(String cropName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropVarietyList,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawMessage = data['message'];
      final List<dynamic> listData = rawMessage is List
          ? rawMessage
          : (rawMessage is Map && rawMessage['data'] is List
                ? rawMessage['data'] as List
                : (data['data'] is List ? data['data'] as List : []));

      final Map<String, CropVariety> uniqueVarieties = {};

      for (var json in listData) {
        final dto = CropVarietyModel.fromJson(json);
        if (dto.name.isEmpty) continue;

        uniqueVarieties[dto.name] = dto.toEntity(ApiConstants.baseUrl);
      }

      return Success(uniqueVarieties.values.toList());
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching varieties: $e');
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CropInfo>> getCropInfo(String cropName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropBasicDetails,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object? rawData = data['data'];

      if (rawData == null) {
        return const Error(ServerFailure(message: 'No crop data available'));
      }

      if (rawData is! Map<String, dynamic>) {
        return const Error(
          ServerFailure(message: 'Unexpected format for crop basic details'),
        );
      }

      final crop = rawData['crop_name']?.toString() ?? cropName;

      String imageUrl = rawData['image']?.toString() ?? '';
      if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
        imageUrl = '${ApiConstants.baseUrl}$imageUrl';
      }

      return Success(
        CropInfo(
          name: crop,
          cropName: crop,
          scientificName: rawData['scientific_name']?.toString() ?? '',
          cropDescription:
              rawData['description']?.toString() ??
              rawData['crop_description']?.toString() ??
              rawData['expert_recommendation']?.toString() ??
              '',
          imageUrl: imageUrl,
          soilType: rawData['soil_type']?.toString() ?? '',
          waterRequirement: rawData['water_intensive']?.toString() ?? '',
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching crop info: $e');
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CropBasicDetails>> getCropBasicDetails(String cropName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropBasicDetails,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> resData =
          response.data as Map<String, dynamic>;
      final Object? rawData = resData['data'];
      if (rawData == null) {
        return const Error(
          ServerFailure(message: 'No basic crop details returned'),
        );
      }

      if (rawData is Map<String, dynamic>) {
        final model = CropBasicDetailsModel.fromJson(rawData);
        return Success(model.toEntity());
      }

      return const Error(
        ServerFailure(
          message: 'Invalid response format for crop basic details',
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching crop basic details: $e');
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CropRiskAndCare>> getRiskAndCare(String cropName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getRiskAndCare,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> resData =
          response.data as Map<String, dynamic>;
      final Object? rawData = resData['data'];
      if (rawData == null) {
        return const Error(
          ServerFailure(message: 'No risk and care details returned'),
        );
      }

      if (rawData is! Map<String, dynamic>) {
        return const Error(
          ServerFailure(message: 'Unexpected format for risk and care data'),
        );
      }
      final data = CropRiskAndCare.fromJson(rawData);
      return Success(data);
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching crop risk and care: $e');
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CropRequirement>> getCropRequirements(String cropName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropRequirements,
        queryParameters: {'crop': cropName},
      );

      final Map<String, dynamic> resData =
          response.data as Map<String, dynamic>;
      final Object? rawData = resData['data'];
      if (rawData == null) {
        return const Error(
          ServerFailure(message: 'No crop requirements returned'),
        );
      }

      if (rawData is! Map<String, dynamic>) {
        return const Error(
          ServerFailure(
            message: 'Unexpected format for crop requirements data',
          ),
        );
      }
      final data = CropRequirement.fromJson(rawData);
      return Success(data);
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching crop requirements: $e');
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CropVarietyDetail?>> getCropVarietyDetails(
    String varietyName, {
    String? season,
  }) async {
    try {
      final queryParams = {
        'crop_variety': _normalizeVariety(varietyName),
        'crop_season': season != null ? _normalizeSeason(season) : null,
      };

      final response = await _dio.get(
        ApiConstants.getCropVarietyDetails,
        queryParameters: queryParams,
      );

      final Map<String, dynamic> resData =
          response.data as Map<String, dynamic>;
      final Object? rawMsg = resData['message'];
      final Object? data =
          (rawMsg is Map ? rawMsg['data'] : null) ?? resData['data'] ?? rawMsg;

      if (data == null || (data is Map && data.isEmpty)) {
        return const Success(null);
      }

      Map<String, dynamic> detailJson;
      if (data is Map && data.containsKey('name')) {
        detailJson = data as Map<String, dynamic>;
      } else if (data is Map && data.isNotEmpty) {
        final firstVal = data.values.first;
        if (firstVal is Map && firstVal.containsKey('name')) {
          detailJson = firstVal as Map<String, dynamic>;
        } else if (data.containsKey('data') && data['data'] is Map) {
          detailJson = data['data'] as Map<String, dynamic>;
        } else {
          detailJson = data as Map<String, dynamic>;
        }
      } else if (data is List && data.isNotEmpty) {
        detailJson = data.first as Map<String, dynamic>;
      } else {
        return const Success(null);
      }

      final dto = CropVarietyDetailModel.fromJson(
        detailJson['name'] ?? '',
        detailJson,
      );
      return Success(dto.toEntity());
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getAvailableSeasons(String varietyName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropVarietyDetails,
        queryParameters: {'crop_variety': _normalizeVariety(varietyName)},
      );

      final Object? root = response.data;
      Object? rawData;
      if (root is Map) {
        final Object? message = root['message'] ?? root['data'];
        rawData = message is Map ? message['data'] ?? message : message;
      } else if (root is List) {
        rawData = root;
      }

      final List<dynamic> dataList = [];
      if (rawData is Map) {
        dataList.addAll(rawData.values);
      } else if (rawData is List) {
        dataList.addAll(rawData);
      }

      final seasons = dataList
          .map((v) {
            if (v is Map<String, dynamic>) {
              return (v['crop_season'] ?? v['season'])?.toString();
            }
            return null;
          })
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

      seasons.sort();
      return Success(seasons);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getAvailableCropSeasons(String name) async {
    try {
      final response = await _dio.get(
        ApiConstants.getCropSeasons,
        queryParameters: {'crop': name},
      );

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final Object root = data;
      List<dynamic> rawList = [];

      if (root is Map) {
        final msg = root['message'];
        final dataField = root['data'];

        if (msg is List) {
          rawList = msg;
        } else if (msg is Map) {
          final inner = msg['data'];
          if (inner is List) {
            rawList = inner;
          } else if (inner is Map) {
            rawList = inner.values.toList();
          } else {
            rawList = msg.values.toList();
          }
        } else if (dataField is List) {
          rawList = dataField;
        } else if (dataField is Map) {
          final inner = dataField['data'];
          rawList = inner is List ? inner : dataField.values.toList();
        }
      } else if (root is List) {
        rawList = root;
      }

      final seasons = rawList
          .map((item) {
            if (item is String) return item.trim();
            if (item is Map) {
              final val =
                  item['season'] ??
                  item['crop_season'] ??
                  item['name'] ??
                  item['value'];
              return val?.toString().trim() ?? '';
            }
            return item?.toString().trim() ?? '';
          })
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

      seasons.sort();
      return Success(seasons);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  /// Normalizes variety names by stripping the 'Co ' prefix.
  /// Standardizes input for API consistency.
  ///
  /// Input: 'Co 86032' -> Output: '86032'
  String _normalizeVariety(String name) {
    if (kDebugMode) {
      assert(name.isNotEmpty, 'Variety name must not be empty');
    }
    return name.replaceAll('Co ', '').trim();
  }

  /// Normalizes season names to lowercase and trims whitespace.
  /// Ensures consistent matching with API parameters.
  ///
  /// Input: 'Suru ' -> Output: 'suru'
  String _normalizeSeason(String season) {
    return season.toLowerCase().trim();
  }
}
