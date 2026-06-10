class VehicleDTO {
  final int? vehicleId;
  final String? brand;
  final String? model;
  final int? year;
  final String? color;
  final String? licensePlate;
  final String? vehicleType;
  final int? odo;
  final double? batteryCapacity;
  final int? range;
  final int? chargingTime;
  final String? style;
  final bool? bodyInsurance;
  final bool? vehicleInspection;
  final String? origin;
  final int? yearManufacture;
  final int? numberOfSeat;
  final String? version;

  VehicleDTO({
    this.vehicleId,
    this.brand,
    this.model,
    this.year,
    this.color,
    this.licensePlate,
    this.vehicleType,
    this.odo,
    this.batteryCapacity,
    this.range,
    this.chargingTime,
    this.style,
    this.bodyInsurance,
    this.vehicleInspection,
    this.origin,
    this.yearManufacture,
    this.numberOfSeat,
    this.version,
  });

  factory VehicleDTO.fromJson(Map<String, dynamic> json) {
    return VehicleDTO(
      vehicleId: json['vehicleId'] as int?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      year: json['year'] as int?,
      color: json['color'] as String?,
      licensePlate: json['licensePlate'] as String?,
      vehicleType: json['vehicleType'] as String?,
      odo: json['odo'] as int?,
      batteryCapacity: (json['batteryCapacity'] as num?)?.toDouble(),
      range: json['range'] as int?,
      chargingTime: json['chargingTime'] as int?,
      style: json['style'] as String?,
      bodyInsurance: json['bodyInsurance'] as bool?,
      vehicleInspection: json['vehicleInspection'] as bool?,
      origin: json['origin'] as String?,
      yearManufacture: json['yearManufacture'] as int?,
      numberOfSeat: json['numberOfSeat'] as int?,
      version: json['version'] as String?,
    );
  }
}
