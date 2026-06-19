import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_info.freezed.dart';
part 'product_info.g.dart';

@freezed
sealed class ProductInfo with _$ProductInfo {
  const factory ProductInfo.vehicle({
    required String name,
    required String brand,
    required String model,
    required String version,
    required int yearManufacture,
    required double batteryCapacity,
    required int odo,
    required String color,
    required double price,
  }) = VehicleInfo;

  const factory ProductInfo.battery({
    required String name,
    required String serialNumber,
    required double originalCapacity,
    required double remainingCapacity,
    required double voltage,
    required int cycleCount,
    required String warranty,
    required int mileageCovered,
    required double price,
  }) = BatteryInfo;

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);
}
