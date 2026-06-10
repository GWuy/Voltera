import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'auth_interceptor.dart';

/// Singleton Dio HTTP client for the Voltera app.
///
/// All services share this single [Dio] instance rather than creating
/// their own. This enables centralized configuration, interceptors,
/// and connection pooling.
///
/// Usage:
/// ```dart
/// final client = ApiClient.instance;
/// final response = await client.dio.get('/endpoint');
/// ```
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.rootApi,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    _dio.interceptors.add(AuthInterceptor());
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  /// The shared [Dio] instance.
  Dio get dio => _dio;

  /// Creates a [Dio] instance **without** the auth interceptor.
  ///
  /// Used for public endpoints that don't require authentication
  /// (e.g., login, register, OTP).
  static Dio createPublicDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.rootApi,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
