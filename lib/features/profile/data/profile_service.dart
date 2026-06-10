import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'profile_request.dart';
import 'profile_response.dart';

class ProfileService {
  ProfileService() : _dio = ApiClient.instance.dio;

  final Dio _dio;

  /// GET /api/v1/users/me/profile
  Future<ProfileResponse> getMyProfile() async {
    try {
      final response = await _dio.get('/api/v1/users/me/profile');
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('ProfileService GET: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  /// ✅ PUT /api/v1/users/me/profile — JSON only
  Future<ProfileResponse> saveProfile(ProfileRequest request) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/me/profile',
        data: request.toJson(),
      );
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('ProfileService PUT: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  /// POST /api/v1/auth/logout?username={username}
  Future<void> logout(String username) async {
    try {
      await _dio.post(
        '/api/v1/auth/logout',
        queryParameters: {'username': username},
      );
    } on DioException catch (e) {
      debugPrint('Logout error: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
