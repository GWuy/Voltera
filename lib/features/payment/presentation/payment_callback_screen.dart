// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../core/router/route_names.dart';
// import '../data/payment_repository_impl.dart';
//
// class PaymentCallbackScreen extends ConsumerStatefulWidget {
//   final int transactionId;
//   final String? initialStatus;
//
//   const PaymentCallbackScreen({
//     super.key,
//     required this.transactionId,
//     this.initialStatus,
//   });
//
//   @override
//   ConsumerState<PaymentCallbackScreen> createState() => _PaymentCallbackScreenState();
// }
//
// class _PaymentCallbackScreenState extends ConsumerState<PaymentCallbackScreen> {
//   static const _pollInterval = Duration(seconds: 3);
//   static const _timeout = Duration(seconds: 60);
//
//   Timer? _pollTimer;
//   Timer? _timeoutTimer;
//   String _status = 'CHECKING';
//   bool _isPolling = true;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialStatus == 'CANCELLED') {
//       _stopPolling();
//       WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToResult('CANCELLED'));
//       return;
//     }
//     _startPolling();
//   }
//
//   void _startPolling() {
//     _pollTimer = Timer.periodic(_pollInterval, (_) => _checkStatus());
//     _timeoutTimer = Timer(_timeout, () {
//       _stopPolling();
//       if (mounted) {
//         setState(() => _status = 'TIMEOUT');
//         _navigateToResult('FAILED');
//       }
//     });
//     _checkStatus(); // first check immediately
//   }
//
//   void _stopPolling() {
//     _pollTimer?.cancel();
//     _timeoutTimer?.cancel();
//     setState(() => _isPolling = false);
//   }
//
//   Future<void> _checkStatus() async {
//     try {
//       final repo = ref.read(paymentRepositoryProvider);
//       final result = await repo.getTransactionStatus(widget.transactionId);
//       final status = result.transactionStatus;
//
//       setState(() => _status = status);
//
//       if (status == 'DONE' || status == 'PAID') {
//         _stopPolling();
//         if (mounted) _navigateToResult('PAID');
//       } else if (status == 'FAILED' || status == 'CANCELLED') {
//         _stopPolling();
//         if (mounted) _navigateToResult(status);
//       }
//     } catch (e) {
//       debugPrint('Error polling transaction status: $e');
//     }
//   }
//
//   void _navigateToResult(String status) {
//     if (!mounted) return;
//     if (status == 'PAID' || status == 'DONE') {
//       context.go('${RouteNames.paymentSuccess}?transactionId=${widget.transactionId}');
//     } else {
//       context.go('${RouteNames.paymentFailed}?transactionId=${widget.transactionId}&status=$status');
//     }
//   }
//
//   @override
//   void dispose() {
//     _stopPolling();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(color: Color(0xFF3D3DC6)),
//               const SizedBox(height: 32),
//               const Text(
//                 'Verifying Payment',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Please wait while we confirm your transaction...',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
//               ),
//               const SizedBox(height: 24),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3D3DC6).withValues(alpha: 0.08),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   'Status: $_status',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF3D3DC6),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
