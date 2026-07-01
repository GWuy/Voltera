import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ChatService {
  ChatService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<List<ConversationModel>> getConversations() async {
    final response = await _dio.get<List<dynamic>>('/api/v1/chat/conversations');
    final data = response.data ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(ConversationModel.fromJson)
        .toList();
  }

  Future<List<ChatMessageModel>> getMessages({
    required String receiverId,
    int page = 0,
    int size = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/chat/messages/$receiverId',
      queryParameters: {'page': page, 'size': size},
    );
    final content = response.data?['content'];
    final items = content is List ? content : const [];

    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => ChatMessageModel.fromJson(
              json,
              receiverId: receiverId,
            ))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/chat/messages',
      data: {
        'receiverId': int.tryParse(receiverId),
        'content': content,
        'messageType': type.wireName,
      },
    );

    return ChatMessageModel.fromJson(
      response.data ?? const {},
      receiverId: receiverId,
    );
  }

  Future<void> markMessagesAsRead({required String senderId}) {
    return _dio.put<void>('/api/v1/chat/messages/$senderId/read');
  }
}
