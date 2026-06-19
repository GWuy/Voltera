import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../home/data/models/post_response.dart';

class ProductApiService {
  ProductApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

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
      final params = <String, dynamic>{};
      if (keyword != null) params['keyword'] = keyword;
      if (address != null) params['address'] = address;
      if (brand != null) params['brand'] = brand;
      if (version != null) params['version'] = version;
      if (color != null) params['color'] = color;
      if (origin != null) params['origin'] = origin;
      if (style != null) params['style'] = style;
      if (minOdo != null) params['minOdo'] = minOdo;
      if (maxOdo != null) params['maxOdo'] = maxOdo;
      if (minRange != null) params['minRange'] = minRange;
      if (maxRange != null) params['maxRange'] = maxRange;
      if (bodyInsurance != null) params['bodyInsurance'] = bodyInsurance;
      if (vehicleInspection != null)
        params['vehicleInspection'] = vehicleInspection;
      if (minPrice != null) params['minPrice'] = minPrice;
      if (maxPrice != null) params['maxPrice'] = maxPrice;
      if (minYearManufacture != null)
        params['minYearManufacture'] = minYearManufacture;
      if (maxYearManufacture != null)
        params['maxYearManufacture'] = maxYearManufacture;
      if (numberOfSeat != null) params['numberOfSeat'] = numberOfSeat;

      final response = await _dio.get(
        '/api/post/filter/vehicles',
        queryParameters: params,
      );
      final list = response.data as List;
      return list
          .map((e) => PostResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint(
        'ProductApiService FILTER: ${e.response?.statusCode} ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<PostResponse> getPostDetail(int postId) async {
    try {
      final response = await _dio.get('/api/post/detail/$postId');
      return PostResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint(
        'ProductApiService DETAIL: ${e.response?.statusCode} ${e.response?.data}',
      );
      rethrow;
    }
  }
}
