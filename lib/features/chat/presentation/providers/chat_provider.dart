import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/models/conversation_model.dart';
import '../../domain/repositories/chat_repository.dart';

/// Manages chat state for both conversation list and individual chat screens.
class ChatProvider extends ChangeNotifier {
  ChatProvider({required ChatRepository repository})
      : _repository = repository;

  final ChatRepository _repository;

  // ── Conversation list state ──────────────────────────────────────────
  List<ConversationModel> _conversations = [];
  bool _conversationsLoading = true;
  String? _conversationsError;
  StreamSubscription<List<ConversationModel>>? _conversationsSub;

  List<ConversationModel> get conversations => _conversations;
  bool get conversationsLoading => _conversationsLoading;
  String? get conversationsError => _conversationsError;

  // ── Messages state ───────────────────────────────────────────────────
  List<ChatMessageModel> _messages = [];
  bool _messagesLoading = true;
  String? _messagesError;
  bool _sending = false;
  StreamSubscription<List<ChatMessageModel>>? _messagesSub;

  List<ChatMessageModel> get messages => _messages;
  bool get messagesLoading => _messagesLoading;
  String? get messagesError => _messagesError;
  bool get sending => _sending;

  // ── Conversation list ────────────────────────────────────────────────

  /// Starts listening to the conversation list for [currentUserId].
  void listenConversations(String currentUserId) {
    _conversationsLoading = true;
    _conversationsError = null;
    notifyListeners();

    _conversationsSub?.cancel();
    _conversationsSub =
        _repository.conversationsStream(currentUserId).listen(
      (list) {
        _conversations = list;
        _conversationsLoading = false;
        _conversationsError = null;
        notifyListeners();
      },
      onError: (Object error) {
        _conversationsError = error.toString();
        _conversationsLoading = false;
        notifyListeners();
      },
    );
  }

  // ── Messages ─────────────────────────────────────────────────────────

  /// Starts listening to messages in a conversation.
  void listenMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    _messagesLoading = true;
    _messagesError = null;
    notifyListeners();

    final convoId = _repository.conversationId(currentUserId, otherUserId);

    _messagesSub?.cancel();
    _messagesSub = _repository.messagesStream(convoId).listen(
      (list) {
        _messages = list;
        _messagesLoading = false;
        _messagesError = null;
        notifyListeners();

        // Mark incoming messages as read
        _repository.markMessagesAsRead(
          conversationId: convoId,
          currentUserId: currentUserId,
        );
      },
      onError: (Object error) {
        _messagesError = error.toString();
        _messagesLoading = false;
        notifyListeners();
      },
    );
  }

  /// Sends a text message.
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    _sending = true;
    notifyListeners();

    try {
      await _repository.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: content.trim(),
      );
    } catch (e) {
      _messagesError = e.toString();
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  /// Generates a conversation ID helper.
  String conversationId(String userId1, String userId2) =>
      _repository.conversationId(userId1, userId2);

  // ── Cleanup ──────────────────────────────────────────────────────────

  /// Stops listening to messages (call when leaving chat screen).
  void stopListeningMessages() {
    _messagesSub?.cancel();
    _messagesSub = null;
    _messages = [];
    _messagesLoading = true;
    _messagesError = null;
  }

  @override
  void dispose() {
    _conversationsSub?.cancel();
    _messagesSub?.cancel();
    super.dispose();
  }
}
