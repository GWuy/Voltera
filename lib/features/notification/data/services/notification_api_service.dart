import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationApiService {
  NotificationApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await _dio.get('/api/notifications');
    final data = response.data as List;
    return data
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(int notificationId) async {
    await _dio.put('/api/notifications/$notificationId/read');
  }

  Future<void> deleteNotification(int notificationId) async {
    await _dio.delete('/api/notifications/$notificationId');
  }

  Future<void> markAllAsRead() async {
    await _dio.put('/api/notifications/read-all');
  }
}
