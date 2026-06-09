import 'battery_dto.dart';
import 'vehicle_dto.dart';

class PostResponse {
  final int? postId;
  final String? title;
  final String? description;
  final double? price;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BatteryDTO? battery;
  final VehicleDTO? vehicle;
  final List<String> imageUrls;
  final String? location;
  final String? thumbnail;
  final String? feeStatus;

  PostResponse({
    this.postId,
    this.title,
    this.description,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.battery,
    this.vehicle,
    this.imageUrls = const [],
    this.location,
    this.thumbnail,
    this.feeStatus,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      postId: json['postId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      battery: json['battery'] != null
          ? BatteryDTO.fromJson(json['battery'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleDTO.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      location: json['location'] as String?,
      thumbnail: json['thumbnail'] as String?,
      feeStatus: json['feeStatus'] as String?,
    );
  }

  /// Returns true if this post is for a battery listing (no vehicle info).
  bool get isBattery => battery != null && vehicle == null;

  /// Returns true if this post is for a car listing.
  bool get isCar => vehicle != null;
}
