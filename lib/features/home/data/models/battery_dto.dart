import 'battery_type_dto.dart';

class BatteryDTO {
  final String? serialNumber;
  final double? originCapacity;
  final double? remainingCapacity;
  final int? mileageCovered;
  final double? voltage;
  final int? cycleCount;
  final String? warranty;
  final double? weight;
  final String? lifecycle;
  final BatteryTypeDTO? batteryTypeId;

  BatteryDTO({
    this.serialNumber,
    this.originCapacity,
    this.remainingCapacity,
    this.mileageCovered,
    this.voltage,
    this.cycleCount,
    this.warranty,
    this.weight,
    this.lifecycle,
    this.batteryTypeId,
  });

  factory BatteryDTO.fromJson(Map<String, dynamic> json) {
    return BatteryDTO(
      serialNumber: json['serialNumber'] as String?,
      originCapacity: (json['originCapacity'] as num?)?.toDouble(),
      remainingCapacity: (json['remainingCapacity'] as num?)?.toDouble(),
      mileageCovered: json['mileageCovered'] as int?,
      voltage: (json['voltage'] as num?)?.toDouble(),
      cycleCount: json['cycleCount'] as int?,
      warranty: json['warranty'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      lifecycle: json['lifecycle'] as String?,
      batteryTypeId: json['batteryTypeId'] != null
          ? BatteryTypeDTO.fromJson(
              json['batteryTypeId'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
