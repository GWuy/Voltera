import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

/// Low-level Firestore operations for the chat feature.
class ChatService {
  ChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _conversations = 'conversations';
  static const _messages = 'messages';

  /// Generates a deterministic conversation ID from two user IDs.
  String conversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  /// Returns a realtime stream of messages for a conversation.
  Stream<List<ChatMessageModel>> messagesStream(String conversationId) {
    return _firestore
        .collection(_conversations)
        .doc(conversationId)
        .collection(_messages)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  /// Returns a realtime stream of conversations for a user.
  Stream<List<ConversationModel>> conversationsStream(String currentUserId) {
    return _firestore
        .collection(_conversations)
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromFirestore(doc))
            .toList());
  }

  /// Sends a message and updates the conversation metadata atomically.
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.TEXT,
  }) async {
    final convoId = conversationId(senderId, receiverId);
    final convoRef = _firestore.collection(_conversations).doc(convoId);
    final now = DateTime.now();

    final message = ChatMessageModel(
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      createdAt: now,
      type: type,
    );

    final batch = _firestore.batch();

    // Add message document
    final messageRef = convoRef.collection(_messages).doc();
    batch.set(messageRef, message.toFirestore());

    // Create or update conversation document
    batch.set(
      convoRef,
      {
        'participants': [senderId, receiverId],
        'lastMessage': content,
        'lastSenderId': senderId,
        'lastMessageTime': Timestamp.fromDate(now),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  /// Marks all unread messages from the other user as read.
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String currentUserId,
  }) async {
    final snapshot = await _firestore
        .collection(_conversations)
        .doc(conversationId)
        .collection(_messages)
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
