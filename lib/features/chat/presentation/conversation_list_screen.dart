import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/conversation_model.dart';
import 'providers/chat_provider.dart';

/// Displays the list of conversations for the current user.
class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().listenConversations(widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        centerTitle: true,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (provider.conversationsError != null) {
            return _ErrorView(
              message: provider.conversationsError!,
              onRetry: () =>
                  provider.listenConversations(widget.currentUserId),
            );
          }

          if (provider.conversationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.conversations.isEmpty) {
            return const _EmptyView();
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.conversations.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 76),
            itemBuilder: (context, index) {
              final conversation = provider.conversations[index];
              return _ConversationTile(
                conversation: conversation,
                currentUserId: widget.currentUserId,
              );
            },
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  final ConversationModel conversation;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final otherUserId = conversation.otherParticipantId(currentUserId);
    final timeStr = _formatTime(conversation.lastMessageTime);
    final isMyMessage = conversation.lastSenderId == currentUserId;

    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        child: Text(
          otherUserId.isNotEmpty ? otherUserId[0].toUpperCase() : '?',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        'User $otherUserId',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        isMyMessage
            ? 'Bạn: ${conversation.lastMessage}'
            : conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey.shade600),
      ),
      trailing: Text(
        timeStr,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      onTap: () {
        context.push(
          '${RouteNames.chat}?receiverId=$otherUserId&receiverName=User $otherUserId',
          extra: {'currentUserId': currentUserId},
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút';
    if (diff.inDays < 1) return DateFormat('HH:mm').format(dateTime);
    if (diff.inDays < 7) return DateFormat('EEE').format(dateTime);
    return DateFormat('dd/MM').format(dateTime);
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có cuộc trò chuyện nào',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
