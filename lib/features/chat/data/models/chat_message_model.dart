import 'package:cloud_firestore/cloud_firestore.dart';

/// Supported message types.
enum MessageType { TEXT, IMAGE }

/// Represents a single chat message stored in Firestore.
class ChatMessageModel {
  final String? id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final MessageType type;

  const ChatMessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.type = MessageType.TEXT,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] as bool? ?? false,
      type: MessageType.values.firstWhere(
        (e) => e.name == (data['type'] as String? ?? 'TEXT'),
        orElse: () => MessageType.TEXT,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'type': type.name,
    };
  }

  ChatMessageModel copyWith({bool? isRead}) {
    return ChatMessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
    );
  }
}
