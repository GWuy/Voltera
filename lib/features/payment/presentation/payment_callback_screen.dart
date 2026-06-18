import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../transaction/providers/transaction_providers.dart';

class PaymentCallbackScreen extends ConsumerStatefulWidget {
  final int transactionId;
  final String? initialStatus;

  const PaymentCallbackScreen({super.key, required this.transactionId, this.initialStatus});

  @override
  ConsumerState<PaymentCallbackScreen> createState() => _PaymentCallbackScreenState();
}

class _PaymentCallbackScreenState extends ConsumerState<PaymentCallbackScreen> {
  Timer? _pollTimer;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus == 'cancelled') {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goFailed('CANCELLED'));
      return;
    }
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _timeoutTimer = Timer(const Duration(seconds: 60), () => _goFailed('FAILED'));
  }

  Future<void> _poll() async {
    try {
      final tx = await ref.read(transactionDetailProvider(widget.transactionId).future);
      final status = (tx.transactionStatus ?? '').toUpperCase();
      if (status == 'PAID') _goSuccess();
      if (status == 'FAILED' || status == 'CANCELLED') _goFailed(status);
    } catch (_) {}
  }

  void _goSuccess() { _stop(); if (mounted) context.go('${RouteNames.paymentSuccess}?transactionId=${widget.transactionId}'); }
  void _goFailed(String status) { _stop(); if (mounted) context.go('${RouteNames.paymentFailed}?transactionId=${widget.transactionId}&status=$status'); }
  void _stop() { _pollTimer?.cancel(); _timeoutTimer?.cancel(); }

  @override
  void dispose() { _stop(); super.dispose(); }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}