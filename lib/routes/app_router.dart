import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    // ── Login ──────────────────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LoginScreen(message: extra?['message'] as String?);
      },
    ),

    // ── Register ───────────────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),

    // ── Verify Email (OTP) ─────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.verifyEmail,
      builder: (context, state) {
        final extra = (state.extra as Map<String, dynamic>?) ?? {};
        final email = extra['email'] as String? ?? '';
        final registrationData =
            (extra['registrationData'] as Map<String, dynamic>?) ?? {};
        return OtpScreen(
          email: email,
          registrationData: registrationData,
        );
      },
    ),
  ],
);
