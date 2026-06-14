import '../../../home/data/models/post_response.dart';

abstract class ProductRepository {
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
  });

  Future<PostResponse> getPostDetail(int postId);
}
