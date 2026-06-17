// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => VehicleInfo(
  name: json['name'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  version: json['version'] as String,
  yearManufacture: (json['yearManufacture'] as num).toInt(),
  batteryCapacity: (json['batteryCapacity'] as num).toDouble(),
  odo: (json['odo'] as num).toInt(),
  color: json['color'] as String,
  price: (json['price'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$VehicleInfoToJson(VehicleInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'model': instance.model,
      'version': instance.version,
      'yearManufacture': instance.yearManufacture,
      'batteryCapacity': instance.batteryCapacity,
      'odo': instance.odo,
      'color': instance.color,
      'price': instance.price,
      'runtimeType': instance.$type,
    };

BatteryInfo _$BatteryInfoFromJson(Map<String, dynamic> json) => BatteryInfo(
  name: json['name'] as String,
  serialNumber: json['serialNumber'] as String,
  originalCapacity: (json['originalCapacity'] as num).toDouble(),
  remainingCapacity: (json['remainingCapacity'] as num).toDouble(),
  voltage: (json['voltage'] as num).toDouble(),
  cycleCount: (json['cycleCount'] as num).toInt(),
  warranty: json['warranty'] as String,
  mileageCovered: (json['mileageCovered'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$BatteryInfoToJson(BatteryInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'serialNumber': instance.serialNumber,
      'originalCapacity': instance.originalCapacity,
      'remainingCapacity': instance.remainingCapacity,
      'voltage': instance.voltage,
      'cycleCount': instance.cycleCount,
      'warranty': instance.warranty,
      'mileageCovered': instance.mileageCovered,
      'price': instance.price,
      'runtimeType': instance.$type,
    };
