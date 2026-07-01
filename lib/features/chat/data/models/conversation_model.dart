class ConversationModel {
  final String id;
  final String type;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    this.type = 'PRIVATE',
    required this.otherUserId,
    this.otherUserName = 'Unknown',
    this.otherUserAvatar,
    this.lastMessage = '',
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? 'PRIVATE',
      otherUserId: json['otherUserId']?.toString() ?? '',
      otherUserName: json['otherUserName'] as String? ?? 'Unknown',
      otherUserAvatar: json['otherUserAvatar'] as String?,
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime:
          DateTime.tryParse(json['lastMessageTime']?.toString() ?? '') ??
              DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  String otherParticipantId(String currentUserId) => otherUserId;
}
