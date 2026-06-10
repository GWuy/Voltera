import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
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
import 'features/favorite/presentation/providers/favorite_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const VolteraApp());
}

class VolteraApp extends StatelessWidget {
  const VolteraApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Create repositories (single instances shared across providers) ───
    final AuthRepository authRepository = AuthRepositoryImpl();
    final PostRepository postRepository = PostRepositoryImpl();
    final ProfileRepository profileRepository = ProfileRepositoryImpl();

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
          create: (_) => FavoriteProvider(),
        ),
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
