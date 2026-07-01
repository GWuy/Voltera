import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_names.dart';

/// Global navigator key – dùng để navigate từ background handler
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Global scaffold messenger key – dùng để show SnackBar mà không cần context
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Background message handler – PHẢI là top-level function (không phải method)
/// vì nó chạy trong isolate riêng khi app bị terminated hoặc ở background.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase đã được init ở main() nên không cần init lại.
  debugPrint('🔕 [FCM Background] title="${message.notification?.title}" '
      'body="${message.notification?.body}"');
}

/// Quản lý toàn bộ vòng đời của Firebase Cloud Messaging.
///
/// Sử dụng:
/// ```dart
/// await FcmService.init();
/// ```
class FcmService {
  FcmService._(); // private constructor – static-only class

  static final _messaging = FirebaseMessaging.instance;

  /// Khởi tạo FCM: đăng ký handler cho cả 3 trạng thái app.
  ///
  /// Gọi một lần duy nhất trong `main()`, SAU `Firebase.initializeApp()`.
  static Future<void> init() async {
    // 1️⃣ Đăng ký background handler (terminated / background)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2️⃣ Foreground handler – app đang mở, Firebase KHÔNG tự hiện notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 3️⃣ Tap handler – user bấm notification khi app ở BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 4️⃣ Tap handler – user bấm notification khi app bị TERMINATED
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 [FCM] App opened from terminated via notification');
      _handleNotificationTap(initialMessage);
    }

    debugPrint('✅ [FCM] FcmService initialized');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Private handlers
  // ─────────────────────────────────────────────────────────────────────────

  /// Xử lý tin nhắn khi app đang mở (foreground).
  /// Hiện SnackBar thay vì system notification vì Firebase không tự làm điều đó.
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 [FCM Foreground] title="${message.notification?.title}" '
        'body="${message.notification?.body}"');

    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? '';

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF3D3DC6),
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (body.isNotEmpty)
                    Text(
                      body,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () => _navigateToNotifications(),
        ),
      ),
    );
  }

  /// Xử lý khi user bấm vào notification từ system tray.
  /// Theo spec Section 13: điều hướng đến Notification Center.
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 [FCM Tap] user tapped notification: '
        'title="${message.notification?.title}"');
    _navigateToNotifications();
  }

  /// Navigate đến màn hình Notification Center.
  static void _navigateToNotifications() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('⚠️ [FCM] navigatorKey context is null, cannot navigate');
      return;
    }
    context.go(RouteNames.notifications);
  }
}
