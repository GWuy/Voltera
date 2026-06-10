import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:voltera/core/network/api_client.dart';
import 'package:voltera/features/home/data/models/post_response.dart';


/// Low-level API service for post/listing endpoints.
///
/// Uses the shared authenticated [Dio] instance from [ApiClient].
class PostApiService {
  PostApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

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

  Future<List<PostResponse>> _fetchList(String path) async {
    try {
      final response = await _dio.get(path);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => PostResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('PostApiService [$path] error: '
          '${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
