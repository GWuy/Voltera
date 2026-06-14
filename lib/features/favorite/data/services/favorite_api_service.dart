import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../models/fav_list_response.dart';

class FavoriteApiService {
  FavoriteApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<List<FavListResponse>> getFavorites() async {
    try {
      final response = await _dio.get('/api/favorites');
      final list = response.data as List;
      return list.map((e) => FavListResponse.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      debugPrint('FavoriteApiService GET: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> addToFavorite(int postId) async {
    try {
      await _dio.post('/api/favorites/add/$postId');
    } on DioException catch (e) {
      debugPrint('FavoriteApiService ADD: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> removeFromFavorite(int postId) async {
    try {
      await _dio.delete('/api/favorites/delete/$postId');
    } on DioException catch (e) {
      debugPrint('FavoriteApiService DELETE: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    }
  }
}
