import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/token_storage.dart';
import '../../profile/data/services/profile_api_service.dart';
import '../data/models/conversation_model.dart';
import 'providers/chat_provider.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentUserId = widget.currentUserId;
      context.read<ChatProvider>().listenConversations(_currentUserId);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _ChatListHeader(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  if (provider.conversationsError != null) {
                    return _ErrorView(
                      message: provider.conversationsError!,
                      onRetry: provider.refreshConversations,
                    );
                  }

                  if (provider.conversationsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.conversations.isEmpty) {
                    return const _EmptyView();
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: provider.refreshConversations,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: provider.conversations.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _ConversationTile(
                          conversation: provider.conversations[index],
                          currentUserId: _currentUserId,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListHeader extends StatelessWidget {
  const _ChatListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ho tro va trao doi giao dich',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMid,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final displayName = conversation.otherUserName.isNotEmpty
        ? conversation.otherUserName
        : 'User $otherUserId';
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          final location = Uri(
            path: RouteNames.chat,
            queryParameters: {
              'receiverId': otherUserId,
              'receiverName': displayName,
            },
          ).toString();

          context.push(location, extra: {'currentUserId': currentUserId});
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasUnread ? AppColors.primaryAlpha35 : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              _ConversationAvatar(
                displayName: displayName,
                avatarUrl: conversation.otherUserAvatar,
                active: hasUnread,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  hasUnread ? FontWeight.w800 : FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(conversation.lastMessageTime),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500,
                            color: hasUnread
                                ? AppColors.primary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage.isNotEmpty
                                ? conversation.lastMessage
                                : 'Chua co tin nhan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: hasUnread
                                  ? AppColors.textDark
                                  : AppColors.textMid,
                            ),
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 10),
                          Container(
                            constraints: const BoxConstraints(minWidth: 22),
                            height: 22,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadCount > 9
                                  ? '9+'
                                  : conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Vua xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phut';
    if (diff.inDays < 1) return DateFormat('HH:mm').format(dateTime);
    if (diff.inDays < 7) return DateFormat('EEE').format(dateTime);
    return DateFormat('dd/MM').format(dateTime);
  }
}

class _ConversationAvatar extends StatelessWidget {
  const _ConversationAvatar({
    required this.displayName,
    required this.avatarUrl,
    required this.active,
  });

  final String displayName;
  final String? avatarUrl;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primaryAlpha15,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  _initials(displayName),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                )
              : null,
        ),
        Positioned(
          right: -1,
          bottom: 2,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: active ? AppColors.success : AppColors.borderLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'V';
    return parts.map((part) => part[0]).take(2).join().toUpperCase();
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

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
                Icons.forum_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chua co cuoc tro chuyen nao',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tin nhan ho tro se hien thi tai day.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMid),
            ),
          ],
        ),
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
