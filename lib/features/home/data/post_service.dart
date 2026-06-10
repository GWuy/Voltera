import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'models/post_response.dart';

class PostService {
  PostService() : _dio = ApiClient.instance.dio;

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

  /// GET /api/post/filter/vehicles
  Future<List<PostResponse>> filterVehicles({
    String? keyword,
    String? address,
    String? brand,
    String? version,
    String? color,
    String? origin,
    String? style,
    int? minOdo,
    int? maxOdo,
    int? minRange,
    int? maxRange,
    bool? bodyInsurance,
    bool? vehicleInspection,
    double? minPrice,
    double? maxPrice,
    int? minYearManufacture,
    int? maxYearManufacture,
    int? numberOfSeat,
  }) async {
    try {
      final response = await _dio.get(
        '/api/post/filter/vehicles',
        queryParameters: {
          if (keyword != null) 'keyword': keyword,
          if (address != null) 'address': address,
          if (brand != null) 'brand': brand,
          if (version != null) 'version': version,
          if (color != null) 'color': color,
          if (origin != null) 'origin': origin,
          if (style != null) 'style': style,
          if (minOdo != null) 'minOdo': minOdo,
          if (maxOdo != null) 'maxOdo': maxOdo,
          if (minRange != null) 'minRange': minRange,
          if (maxRange != null) 'maxRange': maxRange,
          if (bodyInsurance != null) 'bodyInsurance': bodyInsurance,
          if (vehicleInspection != null) 'vehicleInspection': vehicleInspection,
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (minYearManufacture != null) 'minYearManufacture': minYearManufacture,
          if (maxYearManufacture != null) 'maxYearManufacture': maxYearManufacture,
          if (numberOfSeat != null) 'numberOfSeat': numberOfSeat,
        },
      );
      final list = response.data as List;
      return list.map((e) => PostResponse.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  /// GET /api/post/detail/{postId}
  Future<PostResponse> getPostDetail(int postId) async {
    try {
      final response = await _dio.get('/api/post/detail/$postId');
      return PostResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('PostService DETAIL: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
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
