import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltera/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/deeplink/deep_link_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/otp_provider.dart';
import 'features/home/data/repositories/post_repository_impl.dart';
import 'features/home/domain/repositories/post_repository.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/favorite/data/repositories/favorite_repository_impl.dart';
import 'features/favorite/domain/repositories/favorite_repository.dart';
import 'features/favorite/presentation/providers/favorite_provider.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/notification/data/repositories/notification_repository_impl.dart';
import 'features/notification/domain/repositories/notification_repository.dart';
import 'features/notification/presentation/providers/notification_provider.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/presentation/providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ─── Firebase Messaging: xin quyền thông báo ───────────────────────────
  try {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    // In FCM Token ra console để dùng cho test push notification
    final fcmToken = await messaging.getToken();
    debugPrint('📱 FCM Token: $fcmToken');

    // Khởi tạo FCM handlers (foreground, background, tap)
    await FcmService.init();
  } catch (e) {
    debugPrint('⚠️ Firebase Messaging initialization failed or blocked: $e');
  }
  // ────────────────────────────────────────────────────────────────────────

  runApp(const ProviderScope(child: VolteraApp()));
}

class VolteraApp extends StatefulWidget {
  const VolteraApp({super.key});

  @override
  State<VolteraApp> createState() => _VolteraAppState();
}

class _VolteraAppState extends State<VolteraApp> {
  final deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    deepLinkService.init((uri) {
      print('URI = $uri');
    });
  }

  @override
  void dispose() {
    deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepositoryImpl();
    final PostRepository postRepository = PostRepositoryImpl();
    final ProfileRepository profileRepository = ProfileRepositoryImpl();
    final FavoriteRepository favoriteRepository = FavoriteRepositoryImpl();
    final ProductRepository productRepository = ProductRepositoryImpl();
    final NotificationRepository notificationRepository =
        NotificationRepositoryImpl();
    final ChatRepository chatRepository = ChatRepositoryImpl();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OtpProvider(repository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(repository: postRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(repository: profileRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(repository: favoriteRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(repository: productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              NotificationProvider(repository: notificationRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(repository: chatRepository),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Voltera',
        theme: appTheme,
        routerConfig: appRouter,
        // Dùng key dùng chung với FcmService để hiện SnackBar từ handler FCM
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );
  }
}
