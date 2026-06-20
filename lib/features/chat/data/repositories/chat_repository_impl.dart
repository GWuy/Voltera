import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../services/chat_service.dart';

/// Concrete implementation of [ChatRepository] backed by [ChatService].
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({ChatService? service})
      : _service = service ?? ChatService();

  final ChatService _service;

  @override
  String conversationId(String userId1, String userId2) =>
      _service.conversationId(userId1, userId2);

  @override
  Stream<List<ChatMessageModel>> messagesStream(String conversationId) =>
      _service.messagesStream(conversationId);

  @override
  Stream<List<ConversationModel>> conversationsStream(String currentUserId) =>
      _service.conversationsStream(currentUserId);

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.TEXT,
  }) =>
      _service.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        type: type,
      );

  @override
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String currentUserId,
  }) =>
      _service.markMessagesAsRead(
        conversationId: conversationId,
        currentUserId: currentUserId,
      );
}
