enum MessageType {
  text('TEXT'),
  image('IMAGE'),
  file('FILE');

  const MessageType(this.wireName);

  final String wireName;

  static MessageType fromWireName(String? value) {
    return MessageType.values.firstWhere(
      (type) => type.wireName == value,
      orElse: () => MessageType.text,
    );
  }
}

enum MessageDeliveryStatus { sending, sent, failed }

class ChatMessageModel {
  final String? id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final MessageType type;
  final MessageDeliveryStatus deliveryStatus;

  const ChatMessageModel({
    this.id,
    this.conversationId = '',
    required this.senderId,
    this.receiverId = '',
    this.senderName = '',
    this.senderAvatar,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.type = MessageType.text,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json, {
    String receiverId = '',
  }) {
    return ChatMessageModel(
      id: json['id']?.toString(),
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: receiverId,
      senderName: json['senderName'] as String? ?? '',
      senderAvatar: json['senderAvatar'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      type: MessageType.fromWireName(json['messageType'] as String?),
    );
  }

  Map<String, dynamic> toSendJson() {
    return {
      'receiverId': int.tryParse(receiverId),
      'content': content,
      'messageType': type.wireName,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? senderAvatar,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    MessageType? type,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }
}
