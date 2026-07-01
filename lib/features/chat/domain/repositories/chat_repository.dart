import '../../data/models/chat_message_model.dart';
import '../../data/models/conversation_model.dart';

abstract class ChatRepository {
  Future<List<ConversationModel>> getConversations();

  Future<List<ChatMessageModel>> getMessages({
    required String receiverId,
    int page,
    int size,
  });

  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
    MessageType type,
  });

  Future<void> markMessagesAsRead({required String senderId});
}
