import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/notification_provider.dart';
import '../data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.status == NotificationStatus.loading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == NotificationStatus.error && provider.notifications.isEmpty) {
            return Center(child: Text(provider.errorMessage ?? 'Error loading notifications'));
          }

          if (provider.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No notifications yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadNotifications(),
            child: ListView.separated(
              itemCount: provider.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotificationProvider>();
    
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => provider.deleteNotification(notification.id),
      child: ListTile(
        onTap: () {
          if (!notification.readStatus) {
            provider.markAsRead(notification.id);
          }
        },
        leading: CircleAvatar(
          backgroundColor: notification.readStatus ? Colors.grey[200] : const Color(0xFF3D3DC6).withValues(alpha: 0.1),
          child: Icon(
            notification.title.contains('Contract') ? Icons.assignment_outlined : Icons.notifications_outlined,
            color: notification.readStatus ? Colors.grey : const Color(0xFF3D3DC6),
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.readStatus ? FontWeight.normal : FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy HH:mm').format(notification.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: !notification.readStatus 
            ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3D3DC6), shape: BoxShape.circle))
            : null,
      ),
    );
  }
}
