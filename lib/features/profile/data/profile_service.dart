import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';
import 'profile_request.dart';
import 'profile_response.dart';

class ProfileService {
  ProfileService({required String token, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.rootApi,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  /// GET /api/v1/users/me/profile
  Future<ProfileResponse> getMyProfile() async {
    try {
      final response = await _dio.get('/api/v1/users/me/profile');
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('ProfileService GET STATUS: ${e.response?.statusCode}');
      print('ProfileService GET DATA:   ${e.response?.data}');
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
      print('ProfileService PUT STATUS: ${e.response?.statusCode}');
      print('ProfileService PUT DATA:   ${e.response?.data}');
      rethrow;
    }
  }
}
