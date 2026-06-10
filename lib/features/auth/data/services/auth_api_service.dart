import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:voltera/core/config/api_config.dart';
import 'package:voltera/core/network/api_client.dart';
import 'package:voltera/core/network/api_exception.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';


/// Low-level API service for authentication endpoints.
///
/// Uses a public (unauthenticated) [Dio] instance since login/register
/// don't require a Bearer token.
class AuthApiService {
  AuthApiService({Dio? dio})
      : _dio = dio ?? ApiClient.createPublicDio()
          ..options.baseUrl = ApiConfig.authBaseUrl;

  final Dio _dio;

  /// POST /register
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/register',
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('AuthApiService.register: ${e.response?.statusCode}');
      throw ApiException.fromDioException(e);
    }
  }

  /// POST /login
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('AuthApiService.login: ${e.response?.statusCode}');
      throw ApiException.fromDioException(e);
    }
  }
}
