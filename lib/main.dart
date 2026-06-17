import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
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

void main() {
  runApp(const VolteraApp());
}

class VolteraApp extends StatelessWidget {
  const VolteraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepositoryImpl();
    final PostRepository postRepository = PostRepositoryImpl();
    final ProfileRepository profileRepository = ProfileRepositoryImpl();
    final FavoriteRepository favoriteRepository = FavoriteRepositoryImpl();
    final ProductRepository productRepository = ProductRepositoryImpl();
    final NotificationRepository notificationRepository = NotificationRepositoryImpl();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => OtpProvider(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider(repository: postRepository)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(repository: profileRepository)),
        ChangeNotifierProvider(create: (_) => FavoriteProvider(repository: favoriteRepository)),
        ChangeNotifierProvider(create: (_) => ProductProvider(repository: productRepository)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(repository: notificationRepository)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Voltera',
        theme: appTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
