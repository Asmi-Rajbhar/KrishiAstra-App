import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../security/storage_service.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Auth and Language interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. Manage Auth Token
          final secureToken = await SecureStorageService.getToken();
          options.headers['Authorization'] =
              secureToken ?? ApiConstants.apiToken;

          // 2. Manage Language
          final prefs = await SharedPreferences.getInstance();
          final lang = prefs.getString('language_code') ?? 'en';
          options.queryParameters['lang'] = lang;

          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      // Add logging interceptor for debugging
      dio.interceptors.add(LogInterceptor());
    }
  }
}
