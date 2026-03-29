// Language is injected automatically by DioClient's language interceptor.
// Do NOT add 'lang' to individual queryParameters.
import 'package:dio/dio.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/core/error/failures.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/features/success_stories/domain/repositories/i_success_story_repository.dart';
import 'package:krishiastra/app/features/success_stories/data/mappers/story_mapper.dart';

class ApiStoryRepository implements ISuccessStoryRepository {
  final Dio _dio;

  ApiStoryRepository(this._dio);

  @override
  Future<Result<List<StoryDetail>>> getSuccessStories() async {
    try {
      final response = await _dio.get(ApiConstants.getArticleList);
      final Object? rootValue = response.data;
      Object? rawData;
      if (rootValue is Map) {
        final Object? message = rootValue['message'];
        final Object? dataField =
            rootValue['data'] ?? (message is Map ? message['data'] : null);

        if (message is List) {
          rawData = message;
        } else if (dataField is List) {
          rawData = dataField;
        } else if (dataField is Map) {
          rawData = dataField['articles'] ?? dataField['data'] ?? dataField;
        } else if (message is Map) {
          rawData = message['articles'] ?? message['data'] ?? message;
        }
      }

      final List<dynamic> articlesList = [];
      if (rawData is List) {
        articlesList.addAll(rawData);
      } else if (rawData is Map) {
        articlesList.addAll(rawData.values);
      }

      final stories = articlesList
          .whereType<Map<String, dynamic>>()
          .map((json) => StoryMapper.mapToEntity(json))
          .toList();

      return Success(stories);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<StoryDetail>> getStoryDetail(String title) async {
    try {
      final response = await _dio.get(
        ApiConstants.getArticlesDetails,
        queryParameters: {'title': title},
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic> message =
          (responseData['message'] as Map<String, dynamic>?) ?? {};
      final Map<String, dynamic> data =
          (message['data'] as Map<String, dynamic>?) ?? {};
      final Map<String, dynamic> articlesMap =
          (data['articles'] as Map<String, dynamic>?) ?? {};
      final Map<String, dynamic>? articleJson =
          articlesMap[title] as Map<String, dynamic>?;

      if (articleJson != null) {
        return Success(StoryMapper.mapToEntity(articleJson));
      }
      return const Error(ServerFailure(message: 'Article not found'));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
