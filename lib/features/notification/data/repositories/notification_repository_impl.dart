import '../models/notification_model.dart';
import '../services/notification_api_service.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({NotificationApiService? apiService})
      : _apiService = apiService ?? NotificationApiService();

  final NotificationApiService _apiService;

  @override
  Future<List<NotificationModel>> getMyNotifications() =>
      _apiService.getMyNotifications();

  @override
  Future<void> markAsRead(int notificationId) =>
      _apiService.markAsRead(notificationId);

  @override
  Future<void> deleteNotification(int notificationId) =>
      _apiService.deleteNotification(notificationId);

  @override
  Future<void> markAllAsRead() => _apiService.markAllAsRead();
}
