import 'package:flutter/foundation.dart';

import '../../../home/data/models/post_response.dart';
import '../../domain/repositories/product_repository.dart';

enum ProductStatus { idle, loading, success, error }

class ProductProvider extends ChangeNotifier {
  ProductProvider({required ProductRepository repository})
      : _repository = repository;

  final ProductRepository _repository;

  ProductStatus _listStatus = ProductStatus.idle;
  ProductStatus _detailStatus = ProductStatus.idle;
  List<PostResponse> _cars = [];
  PostResponse? _detail;
  String? _errorMessage;

  ProductStatus get listStatus => _listStatus;
  ProductStatus get detailStatus => _detailStatus;
  List<PostResponse> get cars => _cars;
  PostResponse? get detail => _detail;
  String? get errorMessage => _errorMessage;

  Future<void> filterVehicles({
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
    _listStatus = ProductStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _cars = await _repository.filterVehicles(
        keyword: keyword,
        address: address,
        brand: brand,
        version: version,
        color: color,
        origin: origin,
        style: style,
        minOdo: minOdo,
        maxOdo: maxOdo,
        minRange: minRange,
        maxRange: maxRange,
        bodyInsurance: bodyInsurance,
        vehicleInspection: vehicleInspection,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minYearManufacture: minYearManufacture,
        maxYearManufacture: maxYearManufacture,
        numberOfSeat: numberOfSeat,
      );
      _listStatus = ProductStatus.success;
    } catch (e) {
      _listStatus = ProductStatus.error;
      _errorMessage = e.toString();
      debugPrint('ProductProvider filterVehicles: $e');
    }
    notifyListeners();
  }

  Future<void> loadDetail(int postId) async {
    _detailStatus = ProductStatus.loading;
    _detail = null;
    _errorMessage = null;
    notifyListeners();
    try {
      _detail = await _repository.getPostDetail(postId);
      _detailStatus = ProductStatus.success;
    } catch (e) {
      _detailStatus = ProductStatus.error;
      _errorMessage = e.toString();
      debugPrint('ProductProvider loadDetail: $e');
    }
    notifyListeners();
  }
}
