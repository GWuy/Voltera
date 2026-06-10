import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/profile/presentation/fill_profile_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/favorite/presentation/favorite_screen.dart';
import '../features/home/presentation/home_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    // ... (Keep existing routes)
    //profile
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    // ── Favorites ──────────────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.favorites,
      builder: (context, state) => const FavoriteScreen(),
    ),
    //login
    GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen()
    ),
    //register
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    //home
    GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen()
    ),
  ],
);
