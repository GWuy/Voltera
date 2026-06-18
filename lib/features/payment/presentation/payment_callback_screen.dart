import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../transaction/data/transaction_repository_impl.dart';

class PaymentCallbackScreen extends StatefulWidget {
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
  State<PaymentCallbackScreen> createState() => _PaymentCallbackScreenState();
}

class _PaymentCallbackScreenState extends State<PaymentCallbackScreen> {
  Timer? _pollTimer;
  Timer? _timeoutTimer;
  bool _navigated = false;

  final TransactionRepository _transactionRepository = TransactionRepositoryImpl();

  @override
  void initState() {
    super.initState();

    debugPrint(
        'PaymentCallback: tx=${widget.transactionId}'
    );

    debugPrint(
        'PaymentCallback: status=${widget.initialStatus}'
    );

    final status = (widget.initialStatus ?? '').toUpperCase();

    if (status == 'PAID') {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) => _goSuccess(),
      );
      return;
    }

    if (status == 'CANCELLED') {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) => _goFailed('CANCELLED'),
      );
      return;
    }

    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _timeoutTimer = Timer(const Duration(seconds: 60), () => _goFailed('FAILED'));
  }

  Future<void> _poll() async {
    if (_navigated) return;

    try {
      final tx = await _transactionRepository.getTransactionDetail(widget.transactionId);
      final status = (tx.transactionStatus ?? '').toUpperCase();

      if (status == 'PAID') _goSuccess();
      if (status == 'FAILED' || status == 'CANCELLED') _goFailed(status);
    } catch (_) {}
  }

  void _goSuccess() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _stop();
    context.go('${RouteNames.paymentSuccess}?transactionId=${widget.transactionId}');
  }

  void _goFailed(String status) {
    if (_navigated || !mounted) return;
    _navigated = true;
    _stop();
    context.go('${RouteNames.paymentFailed}?transactionId=${widget.transactionId}&status=$status');
  }

  void _stop() {
    _pollTimer?.cancel();
    _timeoutTimer?.cancel();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verifying payment...'),
          ],
        ),
      ),
    );
  }
}
