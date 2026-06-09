import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import 'models/post_response.dart';

class PostService {
  PostService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.rootApi,
                headers: {'Content-Type': 'application/json'},
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  /// Tab "All" — GET /api/post/list/{status}
  Future<List<PostResponse>> getAllPosts({String status = 'APPROVE'}) async {
    return _fetchList('/api/post/list/$status');
  }

  /// Tab "Car" — GET /api/post/public/vehicles
  Future<List<PostResponse>> getVehiclePosts() async {
    return _fetchList('/api/post/public/vehicles');
  }

  /// Tab "Battery" — GET /api/post/public/batteries
  Future<List<PostResponse>> getBatteryPosts() async {
    return _fetchList('/api/post/public/batteries');
  }

  // ── private helper ──────────────────────────────────────────────────────────
  Future<List<PostResponse>> _fetchList(String path) async {
    try {
      final response = await _dio.get(path);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => PostResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('PostService [$path] error: '
          '${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
