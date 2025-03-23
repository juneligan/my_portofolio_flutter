import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';

import 'jwt_token_notifier.dart';

final dioProvider = Provider<DioClient>((ref) {

  final token = ref.watch(jwtTokenProvider);
  return DioClient();
});

class DioClient {
  String? _token;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiRouteNames.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'ContentType': 'application/json'
    },
  ));

  DioClient() : super() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Fetch token from secure storage (e.g., SharedPreferences, Hive, etc.)
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio getDio() {
    return _dio;
  }

  Future<Response> getRequest(String url) async {
    return await _dio.get(url);
  }

  Future<Response> postRequest(String url, Object? data) async {
    return await _dio.post(url, data: data);
  }

  // Mock function to get stored token
  Future<String?> getToken() async {
    return 'your_jwt_token_here';
  }
}