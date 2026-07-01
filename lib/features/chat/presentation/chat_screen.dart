import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/token_storage.dart';
import '../../profile/data/services/profile_api_service.dart';
import '../data/models/chat_message_model.dart';
import 'providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  final String currentUserId;
  final String receiverId;
  final String receiverName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late ChatProvider _chatProvider;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentUserId = widget.currentUserId;
      context.read<ChatProvider>().listenMessages(
            currentUserId: _currentUserId,
            otherUserId: widget.receiverId,
          );
      _resolveCurrentUserId().then((userId) {
        if (!mounted || userId == null || userId.isEmpty) return;
        setState(() => _currentUserId = userId);
      });
    });
  }

  Future<String?> _resolveCurrentUserId() async {
    if (widget.currentUserId.isNotEmpty) return widget.currentUserId;

    final storedUserId = await TokenStorage.instance.getUserId();
    if (storedUserId != null && storedUserId.isNotEmpty) return storedUserId;

    try {
      final profile = await ProfileApiService().getMyProfile();
      final userId = profile.id?.toString();
      if (userId != null && userId.isNotEmpty) {
        await TokenStorage.instance.saveUserId(userId);
      }
      return userId;
    } catch (_) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = context.read<ChatProvider>();
  }

  @override
  void dispose() {
    _chatProvider.stopListeningMessages();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend() async {
    final content = _messageController.text;
    if (content.trim().isEmpty) return;

    _messageController.clear();
    await context.read<ChatProvider>().sendMessage(
          senderId: _currentUserId,
          receiverId: widget.receiverId,
          content: content,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ChatHeader(receiverName: widget.receiverName),
            const _ConnectionBanner(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  if (provider.messagesError != null) {
                    return _ChatErrorView(
                      message: provider.messagesError!,
                      onRetry: () => provider.listenMessages(
                        currentUserId: _currentUserId,
                        otherUserId: widget.receiverId,
                      ),
                    );
                  }

                  if (provider.messagesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.messages.isEmpty) {
                    return const _EmptyMessagesView();
                  }

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      final isMe = message.senderId == _currentUserId;
                      final showDate = index == 0 ||
                          !_isSameDay(
                            provider.messages[index - 1].createdAt,
                            message.createdAt,
                          );

                      return Column(
                        children: [
                          if (showDate) _DateSeparator(date: message.createdAt),
                          _MessageBubble(message: message, isMe: isMe),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _MessageInput(
              controller: _messageController,
              onSend: _handleSend,
              sending: context.select<ChatProvider, bool>((p) => p.sending),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.receiverName});

  final String receiverName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppColors.textDark,
            tooltip: 'Quay lai',
          ),
          _HeaderAvatar(name: receiverName),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Selector<ChatProvider, ChatConnectionStatus>(
                  selector: (_, provider) => provider.connectionStatus,
                  builder: (context, status, _) {
                    final connected = status == ChatConnectionStatus.connected;
                    return Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: connected
                                ? AppColors.success
                                : AppColors.textLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          connected ? 'Dang hoat dong' : 'Dang ket noi',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMid,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
            color: AppColors.textDark,
            tooltip: 'Tuy chon',
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryAlpha15,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'V';
    return parts.map((part) => part[0]).take(2).join().toUpperCase();
  }
}

class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner();

  @override
  Widget build(BuildContext context) {
    return Selector<ChatProvider, ChatConnectionStatus>(
      selector: (_, provider) => provider.connectionStatus,
      builder: (context, status, _) {
        if (status == ChatConnectionStatus.connected) {
          return const SizedBox.shrink();
        }

        final label = status == ChatConnectionStatus.connecting
            ? 'Dang dong bo tin nhan...'
            : 'Mat ket noi, dang thu lai';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 7),
          color: AppColors.primaryAlpha10,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final ChatMessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? AppColors.primary : AppColors.surface;
    final textColor = isMe ? Colors.white : AppColors.textDark;
    final metaColor =
        isMe ? Colors.white.withValues(alpha: 0.72) : AppColors.textLight;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 6),
            bottomRight: Radius.circular(isMe ? 6 : 18),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.createdAt),
                  style: TextStyle(
                    color: metaColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 5),
                  _DeliveryIcon(message: message),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryIcon extends StatelessWidget {
  const _DeliveryIcon({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    if (message.deliveryStatus == MessageDeliveryStatus.sending) {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.white.withValues(alpha: 0.72),
        ),
      );
    }

    if (message.deliveryStatus == MessageDeliveryStatus.failed) {
      return const Icon(Icons.error_outline, size: 14, color: Colors.orange);
    }

    return Icon(
      message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
      size: 15,
      color: message.isRead
          ? AppColors.infoLight
          : Colors.white.withValues(alpha: 0.72),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final label = _isSameDay(date, now)
        ? 'Hom nay'
        : _isSameDay(date, now.subtract(const Duration(days: 1)))
            ? 'Hom qua'
            : DateFormat('dd/MM/yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryAlpha08,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMid,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.sending,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool sending;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Nhap tin nhan...',
                  hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => sending ? null : onSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 46,
            height: 46,
            child: FilledButton(
              onPressed: sending ? null : onSend,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primaryAlpha50,
              ),
              child: sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessagesView extends StatelessWidget {
  const _EmptyMessagesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryAlpha10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.waving_hand_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hay gui loi chao!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bat dau trao doi de duoc ho tro nhanh hon.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMid),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatErrorView extends StatelessWidget {
  const _ChatErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMid),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thu lai'),
            ),
          ],
        ),
      ),
    );
  }
}
