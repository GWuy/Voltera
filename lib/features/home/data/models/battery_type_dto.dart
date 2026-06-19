class BatteryTypeDTO {
  final int? id;
  final String? typeName;
  final String? technical;
  final String? description;

  BatteryTypeDTO({this.id, this.typeName, this.technical, this.description});

  factory BatteryTypeDTO.fromJson(Map<String, dynamic> json) {
    return BatteryTypeDTO(
      id: json['id'] as int?,
      typeName: json['typeName'] as String?,
      technical: json['technical'] as String?,
      description: json['description'] as String?,
    );
  }
}
