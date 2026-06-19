import 'package:flutter/foundation.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

enum NotificationStatus { idle, loading, success, error }

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({required NotificationRepository repository})
    : _repository = repository;

  final NotificationRepository _repository;

  List<NotificationModel> _notifications = [];
  NotificationStatus _status = NotificationStatus.idle;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  NotificationStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get hasUnread => _notifications.any((n) => !n.readStatus);

  Future<void> loadNotifications() async {
    _status = NotificationStatus.loading;
    notifyListeners();

    try {
      _notifications = await _repository.getMyNotifications();
      _status = NotificationStatus.success;
      _errorMessage = null;
    } on ApiException catch (e) {
      _status = NotificationStatus.error;
      _errorMessage = e.userMessage;
    } catch (e) {
      _status = NotificationStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    try {
      await _repository.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          readStatus: true,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      _notifications = _notifications
          .map((n) => n.copyWith(readStatus: true))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _repository.deleteNotification(id);
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }
}
