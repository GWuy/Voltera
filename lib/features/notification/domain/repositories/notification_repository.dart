import 'package:voltera/features/notification/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getMyNotifications();
  Future<void> markAsRead(int notificationId);
  Future<void> deleteNotification(int notificationId);
  Future<void> markAllAsRead();
}
