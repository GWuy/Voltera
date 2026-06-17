class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.readStatus,
  });

  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool readStatus;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      readStatus: json['readStatus'] as bool? ?? false,
    );
  }

  NotificationModel copyWith({bool? readStatus}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      readStatus: readStatus ?? this.readStatus,
    );
  }
}
