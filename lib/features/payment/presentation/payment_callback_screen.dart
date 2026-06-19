import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../providers/payment_callback_provider.dart';

class PaymentCallbackScreen extends ConsumerStatefulWidget {
  final int transactionId;
  final String? initialStatus;
  final String? orderCode;
  final String? paymentMethod;

  const PaymentCallbackScreen({
    super.key,
    required this.transactionId,
    this.initialStatus,
    this.orderCode,
    this.paymentMethod,
  });

  @override
  ConsumerState<PaymentCallbackScreen> createState() =>
      _PaymentCallbackScreenState();
}

class _PaymentCallbackScreenState extends ConsumerState<PaymentCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentCallbackProvider(widget.transactionId).notifier)
          .startPolling(widget.initialStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentCallbackProvider(widget.transactionId));

    ref.listen(paymentCallbackProvider(widget.transactionId), (previous, next) {
      if (next.status == PaymentPollStatus.paid) {
        context.go(
          '${RouteNames.paymentSuccess}?transactionId=${widget.transactionId}',
        );
      } else if (next.status == PaymentPollStatus.cancelled) {
        context.go(
          '${RouteNames.paymentFailed}?transactionId=${widget.transactionId}&status=CANCELLED',
        );
      } else if (next.status == PaymentPollStatus.failed ||
          next.status == PaymentPollStatus.timeout) {
        context.go(
          '${RouteNames.paymentFailed}?transactionId=${widget.transactionId}&status=FAILED',
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xFF3D3DC6)),
                const SizedBox(height: 32),
                const Text(
                  'Verifying Payment',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  state.status == PaymentPollStatus.timeout
                      ? 'Verification timed out. Check transactions list.'
                      : 'Please wait while we confirm your transaction...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
