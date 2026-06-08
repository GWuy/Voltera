import 'package:go_router/go_router.dart';

import '../features/auth/presentation/register_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.register,
  routes: [
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
