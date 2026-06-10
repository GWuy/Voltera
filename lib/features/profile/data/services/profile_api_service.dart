import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:voltera/core/network/api_client.dart';
import 'package:voltera/features/profile/data/models/profile_request.dart';
import 'package:voltera/features/profile/data/models/profile_response.dart';


/// Low-level API service for profile endpoints.
///
/// Uses the shared authenticated [Dio] instance from [ApiClient].
/// The [AuthInterceptor] automatically attaches the Bearer token —
/// no need to pass token via constructor.
class ProfileApiService {
  ProfileApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  /// GET /api/v1/users/me/profile
  Future<ProfileResponse> getMyProfile() async {
    try {
      final response = await _dio.get('/api/v1/users/me/profile');
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint(
          'ProfileApiService GET: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  /// PUT /api/v1/users/me/profile
  Future<ProfileResponse> saveProfile(ProfileRequest request) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/me/profile',
        data: request.toJson(),
      );
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint(
          'ProfileApiService PUT: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
