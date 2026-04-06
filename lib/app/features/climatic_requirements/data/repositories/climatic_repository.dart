// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/features/climatic_requirements/data/models/climatic_requirement_model.dart';
import 'package:krishiastra/app/features/climatic_requirements/domain/entities/climatic_model.dart';
import 'package:krishiastra/app/features/climatic_requirements/domain/repositories/i_climatic_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';

/// Concrete implementation of [IClimaticRepository] using Dio for network requests.
class ClimaticRepository implements IClimaticRepository {
  /// Dio instance for HTTP communication.
  final Dio _dio;

  ClimaticRepository(this._dio);

  /// Fetches climatic conditions from the live API endpoint.
  /// Uses [ClimaticRequirementModel] to parse the response 'data' object.
  @override
  Future<Result<ClimaticRequirement>> getClimaticConditions({
    String? crop,
    String? land,
  }) async {
    try {
      // Calling the actual Frappe/ERPNext method endpoint.
      final response = await _dio.get(
        ApiConstants.getClimaticRequirements,
        queryParameters: {
          if (crop != null && crop.isNotEmpty) 'crop': crop,
          if (land != null && land.isNotEmpty) 'land': land,
        },
      );

      // Robust extraction: handle if response.data itself is a List or Map
      Object? rawData;
      final Object? rootValue = response.data;
      if (rootValue is Map) {
        final Map<String, dynamic> responseData =
            rootValue as Map<String, dynamic>;
        rawData = responseData['data'] ?? responseData['message'];
      } else if (rootValue is List) {
        rawData = rootValue;
      }

      Map<String, dynamic>? data;
      if (rawData is List && rawData.isNotEmpty) {
        data = rawData[0] is Map<String, dynamic> ? rawData[0] : null;
      } else if (rawData is Map<String, dynamic>) {
        // If it's the variety structure containing climate info
        if (rawData.containsKey('crop_climate_requirement')) {
          final list = rawData['crop_climate_requirement'];
          if (list is List && list.isNotEmpty) {
            data = list[0] is Map<String, dynamic> ? list[0] : null;
          }
        } else {
          data = rawData;
        }
      }

      if (data == null || data.isEmpty) {
        return const Error(ServerFailure(message: 'No climatic data found'));
      }

      // Returning the domain entity parsed via the data model.
      return Success(
        ClimaticRequirementModel.fromJson(data, cropName: crop ?? ''),
      );
    } catch (e) {
      return Error(
        ServerFailure(message: 'Failed to fetch climatic conditions: $e'),
      );
    }
  }
}
