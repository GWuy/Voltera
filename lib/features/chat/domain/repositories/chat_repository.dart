import '../../data/models/chat_message_model.dart';
import '../../data/models/conversation_model.dart';

/// Abstract interface for chat operations.
abstract class ChatRepository {
  /// Generates a deterministic conversation ID from two user IDs.
  String conversationId(String userId1, String userId2);

  /// Returns a realtime stream of messages for a conversation.
  Stream<List<ChatMessageModel>> messagesStream(String conversationId);

  /// Returns a realtime stream of conversations for a user.
  Stream<List<ConversationModel>> conversationsStream(String currentUserId);

  /// Sends a message and updates conversation metadata.
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type,
  });

  /// Marks all unread messages from the other user as read.
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String currentUserId,
  });
}
