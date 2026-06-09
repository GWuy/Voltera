class VehicleDTO {
  final int? vehicleId;
  final String? brand;
  final String? model;
  final int? year;
  final String? color;
  final String? licensePlate;
  final String? vehicleType;

  VehicleDTO({
    this.vehicleId,
    this.brand,
    this.model,
    this.year,
    this.color,
    this.licensePlate,
    this.vehicleType,
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
    );
  }
}
