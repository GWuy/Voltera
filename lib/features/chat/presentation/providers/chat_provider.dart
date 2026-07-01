import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/models/conversation_model.dart';
import '../../domain/repositories/chat_repository.dart';

enum ChatConnectionStatus { disconnected, connecting, connected }

class ChatProvider extends ChangeNotifier {
  ChatProvider({required ChatRepository repository}) : _repository = repository;

  final ChatRepository _repository;

  List<ConversationModel> _conversations = [];
  bool _conversationsLoading = true;
  String? _conversationsError;
  Timer? _conversationsPoller;

  List<ConversationModel> get conversations => _conversations;
  bool get conversationsLoading => _conversationsLoading;
  String? get conversationsError => _conversationsError;

  List<ChatMessageModel> _messages = [];
  bool _messagesLoading = true;
  String? _messagesError;
  bool _sending = false;
  bool _typing = false;
  ChatConnectionStatus _connectionStatus = ChatConnectionStatus.disconnected;
  Timer? _messagesPoller;
  String? _activeReceiverId;

  List<ChatMessageModel> get messages => _messages;
  bool get messagesLoading => _messagesLoading;
  String? get messagesError => _messagesError;
  bool get sending => _sending;
  bool get typing => _typing;
  ChatConnectionStatus get connectionStatus => _connectionStatus;

  void listenConversations(String currentUserId) {
    _conversationsPoller?.cancel();
    _conversationsLoading = true;
    _conversationsError = null;
    notifyListeners();

    _loadConversations();
    _conversationsPoller = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _loadConversations(silent: true),
    );
  }

  Future<void> refreshConversations() => _loadConversations();

  Future<void> _loadConversations({bool silent = false}) async {
    if (!silent) {
      _conversationsLoading = true;
      _conversationsError = null;
      notifyListeners();
    }

    try {
      _conversations = await _repository.getConversations();
      _conversationsError = null;
    } catch (error) {
      _conversationsError = error.toString();
    } finally {
      _conversationsLoading = false;
      notifyListeners();
    }
  }

  void listenMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    _messagesPoller?.cancel();
    _activeReceiverId = otherUserId;
    _connectionStatus = ChatConnectionStatus.connecting;
    _messagesLoading = true;
    _messagesError = null;
    notifyListeners();

    _loadMessages(receiverId: otherUserId);
    _messagesPoller = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadMessages(receiverId: otherUserId, silent: true),
    );
  }

  Future<void> refreshMessages() async {
    final receiverId = _activeReceiverId;
    if (receiverId == null || receiverId.isEmpty) return;
    await _loadMessages(receiverId: receiverId);
  }

  Future<void> _loadMessages({
    required String receiverId,
    bool silent = false,
  }) async {
    if (!silent) {
      _messagesLoading = true;
      _messagesError = null;
      notifyListeners();
    }

    try {
      final loaded = await _repository.getMessages(receiverId: receiverId);
      _messages = _mergeMessages(_messages, loaded);
      _messagesError = null;
      _connectionStatus = ChatConnectionStatus.connected;
      await _repository.markMessagesAsRead(senderId: receiverId);
    } catch (error) {
      _messagesError = error.toString();
      _connectionStatus = ChatConnectionStatus.disconnected;
    } finally {
      _messagesLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || _sending) return;

    final localMessage = ChatMessageModel(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      content: trimmed,
      createdAt: DateTime.now(),
      deliveryStatus: MessageDeliveryStatus.sending,
    );

    _sending = true;
    _messages = _mergeMessages(_messages, [localMessage]);
    notifyListeners();

    try {
      final sent = await _repository.sendMessage(
        receiverId: receiverId,
        content: trimmed,
      );
      _replaceLocalMessage(localMessage.id!, sent);
      _messagesError = null;
      await _loadConversations(silent: true);
    } catch (error) {
      _replaceLocalMessage(
        localMessage.id!,
        localMessage.copyWith(deliveryStatus: MessageDeliveryStatus.failed),
      );
      _messagesError = error.toString();
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  void setTyping(bool value) {
    if (_typing == value) return;
    _typing = value;
    notifyListeners();
  }

  void stopListeningMessages() {
    _messagesPoller?.cancel();
    _messagesPoller = null;
    _activeReceiverId = null;
    _messages = [];
    _messagesLoading = true;
    _messagesError = null;
    _typing = false;
    _connectionStatus = ChatConnectionStatus.disconnected;
  }

  List<ChatMessageModel> _mergeMessages(
    List<ChatMessageModel> current,
    List<ChatMessageModel> incoming,
  ) {
    final byId = <String, ChatMessageModel>{};
    final localMessages = <ChatMessageModel>[];

    for (final message in [...current, ...incoming]) {
      final id = message.id;
      if (id == null || id.startsWith('local-')) {
        if (message.deliveryStatus != MessageDeliveryStatus.sent) {
          localMessages.add(message);
        }
        continue;
      }
      byId[id] = message;
    }

    final merged = [...byId.values, ...localMessages]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return merged;
  }

  void _replaceLocalMessage(String localId, ChatMessageModel replacement) {
    _messages = _messages
        .map((message) => message.id == localId ? replacement : message)
        .toList();
    _messages = _mergeMessages(const [], _messages);
  }

  @override
  void dispose() {
    _conversationsPoller?.cancel();
    _messagesPoller?.cancel();
    super.dispose();
  }
}
