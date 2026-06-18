import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/profile/presentation/fill_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/favorite/presentation/favorite_screen.dart';
import '../../features/product/presentation/car_list_screen.dart';
import '../../features/product/presentation/car_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/contract/presentation/contract_preview_screen.dart';
import '../../features/contract/presentation/contract_list_screen.dart';
import '../../features/transaction/presentation/transaction_list_screen.dart';
import '../../features/transaction/presentation/transaction_detail_screen.dart';
import '../../features/payment/presentation/payment_callback_screen.dart';
import '../../features/payment/presentation/payment_failed_screen.dart';
import '../../features/payment/presentation/payment_success_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  redirect: (context, state) {
    // 1. GoRouter natively intercepts Android Intents.
    // 2. When the app is opened via `voltera://payment/callback?id=...`,
    //    GoRouter's `state.uri.toString()` will literally be that string.
    // 3. Since `voltera://` is not a mapped route (routes start with `/`), it throws an error.
    // 4. We must intercept the raw scheme here and redirect it to the valid internal path.
    if (state.uri.scheme == 'voltera' && state.uri.host == 'payment') {
      final path = state.uri.path; // e.g. '/callback'
      final query = state.uri.query; // e.g. 'transactionId=9&code=00'
      final internalRoute = '/payment$path${query.isNotEmpty ? '?$query' : ''}';
      debugPrint('GoRouter Redirecting Deep Link -> $internalRoute');
      return internalRoute;
    }
    return null;
  },
  routes: [
    GoRoute(path: RouteNames.login, builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return LoginScreen(message: extra?['message'] as String?);
    }),
    GoRoute(path: RouteNames.register, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: RouteNames.home, builder: (context, state) => const HomeScreen()),
    GoRoute(path: RouteNames.profile, builder: (context, state) => const ProfileScreen()),
    GoRoute(path: RouteNames.favorites, builder: (context, state) => const FavoriteScreen()),
    GoRoute(path: RouteNames.carList, builder: (context, state) => CarListScreen(brand: state.uri.queryParameters['brand'])),
    GoRoute(
      path: RouteNames.carDetail,
      builder: (context, state) {
        final postId = int.tryParse(state.uri.queryParameters['postId'] ?? '') ?? 0;
        return CarDetailScreen(postId: postId);
      },
    ),
    GoRoute(path: RouteNames.notifications, builder: (context, state) => const NotificationScreen()),
    GoRoute(path: RouteNames.verifyEmail, builder: (context, state) {
      final extra = (state.extra as Map<String, dynamic>?) ?? {};
      return OtpScreen(email: extra['email'] as String? ?? '', registrationData: (extra['registrationData'] as Map<String, dynamic>?) ?? {});
    }),
    GoRoute(path: RouteNames.fillProfile, builder: (context, state) {
      final extra = (state.extra as Map<String, dynamic>?) ?? {};
      return FillProfileScreen(userId: extra['userId'] as int? ?? 0, token: extra['token'] as String? ?? '', role: extra['role'] as String? ?? '');
    }),
    GoRoute(path: RouteNames.contractPreview, builder: (context, state) => ContractPreviewScreen(contractId: state.uri.queryParameters['id'] ?? '1')),
    GoRoute(path: RouteNames.contractList, builder: (context, state) => const ContractListScreen()),
    GoRoute(path: RouteNames.transactionList, builder: (context, state) => const TransactionListScreen()),
    GoRoute(path: RouteNames.transactionDetail, builder: (context, state) => TransactionDetailScreen(transactionId: int.parse(state.uri.queryParameters['id'] ?? '0'))),
    GoRoute(
      path: '/payment/callback',
      builder: (context, state) {

        print('=== CALLBACK ROUTE HIT ===');
        print('URI = ${state.uri}');

        final id = int.tryParse(
          state.uri.queryParameters['transactionId'] ?? '',
        ) ?? 0;

        print('ID = $id');

        return PaymentCallbackScreen(
          transactionId: id,
          initialStatus: state.uri.queryParameters['status'],
          orderCode: state.uri.queryParameters['orderCode'],
          paymentMethod: state.uri.queryParameters['paymentMethod'],
        );
      },
    ),
    GoRoute(path: RouteNames.paymentSuccess, builder: (context, state) => PaymentSuccessScreen(transactionId: int.tryParse(state.uri.queryParameters['transactionId'] ?? '') ?? 0)),
    GoRoute(path: RouteNames.paymentFailed, builder: (context, state) => PaymentFailedScreen(transactionId: int.tryParse(state.uri.queryParameters['transactionId'] ?? '') ?? 0, status: state.uri.queryParameters['status'] ?? 'FAILED')),
  ],
);