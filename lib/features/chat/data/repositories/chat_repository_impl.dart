import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import '../services/chat_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({ChatService? service})
      : _service = service ?? ChatService();

  final ChatService _service;

  @override
  Future<List<ConversationModel>> getConversations() {
    return _service.getConversations();
  }

  @override
  Future<List<ChatMessageModel>> getMessages({
    required String receiverId,
    int page = 0,
    int size = 50,
  }) {
    return _service.getMessages(
      receiverId: receiverId,
      page: page,
      size: size,
    );
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) {
    return _service.sendMessage(
      receiverId: receiverId,
      content: content,
      type: type,
    );
  }

  @override
  Future<void> markMessagesAsRead({required String senderId}) {
    return _service.markMessagesAsRead(senderId: senderId);
  }
}
