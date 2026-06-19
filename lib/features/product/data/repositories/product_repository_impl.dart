import '../../../home/data/models/post_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductApiService? apiService})
    : _apiService = apiService ?? ProductApiService();

  final ProductApiService _apiService;

  @override
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
  }) => _apiService.filterVehicles(
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

  @override
  Future<PostResponse> getPostDetail(int postId) =>
      _apiService.getPostDetail(postId);
}
