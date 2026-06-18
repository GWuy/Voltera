import 'package:go_router/go_router.dart';
import 'package:voltera/features/product/presentation/car_detail_screen.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/profile/presentation/fill_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/favorite/presentation/favorite_screen.dart';
import '../../features/product/presentation/car_list_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/contract/presentation/contract_preview_screen.dart';
import '../../features/contract/presentation/contract_list_screen.dart';
import '../../features/transaction/presentation/transaction_list_screen.dart';
import '../../features/transaction/presentation/transaction_detail_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LoginScreen(message: extra?['message'] as String?);
      },
    ),

    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    GoRoute(
      path: RouteNames.favorites,
      builder: (context, state) => const FavoriteScreen(),
    ),

    GoRoute(
      path: RouteNames.carList,
      builder: (context, state) {
        final brand = state.uri.queryParameters['brand'];
        return CarListScreen(brand: brand);
      },
    ),

    GoRoute(
      path: RouteNames.carDetail,
      builder: (context, state) {
        final postId = int.parse(state.uri.queryParameters['postId'] ?? '0');
        return CarDetailScreen(postId: postId);
      },
    ),

    GoRoute(
      path: RouteNames.notifications,
      builder: (context, state) => const NotificationScreen(),
    ),

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

    GoRoute(
      path: RouteNames.fillProfile,
      builder: (context, state) {
        final extra = (state.extra as Map<String, dynamic>?) ?? {};
        return FillProfileScreen(
          userId: extra['userId'] as int? ?? 0,
          token: extra['token'] as String? ?? '',
          role: extra['role'] as String? ?? '',
        );
      },
    ),

    GoRoute(
      path: RouteNames.contractPreview,
      builder: (context, state) {
        final contractId = state.uri.queryParameters['id'] ?? '1';
        return ContractPreviewScreen(contractId: contractId);
      },
    ),

    GoRoute(
      path: RouteNames.contractList,
      builder: (context, state) => const ContractListScreen(),
    ),

    GoRoute(
      path: RouteNames.transactionList,
      builder: (context, state) => const TransactionListScreen(),
    ),

    GoRoute(
      path: RouteNames.transactionDetail,
      builder: (context, state) {
        final id = int.parse(state.uri.queryParameters['id'] ?? '0');
        return TransactionDetailScreen(transactionId: id);
      },
    ),
  ],
);
