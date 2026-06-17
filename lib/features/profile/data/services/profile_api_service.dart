import 'dart:io';

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

  /// POST /api/upload/avatar
  Future<String> uploadAvatar(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await _dio.post(
        '/api/upload/avatar',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      
      // Assuming the response returns the URL in data or data['url']
      if (response.data is Map && response.data['url'] != null) {
        return response.data['url'] as String;
      }
      return response.data.toString();
    } on DioException catch (e) {
      debugPrint('ProfileApiService UPLOAD AVATAR: ${e.response?.statusCode} ${e.response?.data}');
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
      debugPrint('ProfileApiService LOGOUT: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
