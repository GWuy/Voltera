import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import 'models/fav_list_response.dart';

class FavoriteService {
  FavoriteService() : _dio = ApiClient.instance.dio;

  final Dio _dio;

  /// GET /api/favorites
  Future<List<FavListResponse>> getFavorites() async {
    try {
      final response = await _dio.get('/api/favorites');
      final list = response.data as List;
      return list.map((e) => FavListResponse.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      debugPrint('FavoriteService GET: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  /// POST /api/favorites/add/{postID}
  Future<void> addToFavorite(int postId) async {
    try {
      await _dio.post('/api/favorites/add/$postId');
    } on DioException catch (e) {
      debugPrint('FavoriteService ADD: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  /// DELETE /api/favorites/delete/{postID}
  Future<void> removeFromFavorite(int postId) async {
    try {
      await _dio.delete('/api/favorites/delete/$postId');
    } on DioException catch (e) {
      debugPrint('FavoriteService DELETE: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
