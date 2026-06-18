import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/network/api_client.dart';
import '../../transaction/data/transaction_repository_impl.dart';
import '../../transaction/domain/transaction_model.dart';

enum PaymentPollStatus {
  verifying,
  paid,
  cancelled,
  failed,
  timeout,
}

class PaymentCallbackState {
  final PaymentPollStatus status;
  final String? errorMessage;
  final TransactionModel? transaction;

  PaymentCallbackState({
    required this.status,
    this.errorMessage,
    this.transaction,
  });
}

class PaymentCallbackNotifier extends StateNotifier<PaymentCallbackState> {
  final int transactionId;
  final TransactionRepository _transactionRepository = TransactionRepositoryImpl();
  final _dio = ApiClient.instance.dio;

  Timer? _timer;
  int _secondsElapsed = 0;

  PaymentCallbackNotifier(this.transactionId)
      : super(PaymentCallbackState(status: PaymentPollStatus.verifying));

  Future<void> startPolling(String? initialStatus) async {
    if ((initialStatus ?? '').toUpperCase() == 'CANCELLED') {
      state = PaymentCallbackState(status: PaymentPollStatus.cancelled);
      return;
    }

    await _syncStatus();
    await _poll();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _secondsElapsed += 2;
      if (_secondsElapsed >= 30) {
        timer.cancel();
        state = PaymentCallbackState(
          status: PaymentPollStatus.timeout,
          errorMessage: 'Verification timed out. Webhook update delayed.',
        );
        return;
      }
      _poll();
    });
  }

  Future<void> _syncStatus() async {
    try {
      await _dio.post('/api/payos/sync-status/$transactionId');
    } catch (_) {}
  }

  Future<void> _poll() async {
    try {
      final tx = await _transactionRepository.getTransactionDetail(transactionId);
      final status = (tx.transactionStatus ?? '').toUpperCase();

      if (status == 'PAID' || status == 'DONE' || status == 'APPROVE') {
        _timer?.cancel();
        state = PaymentCallbackState(status: PaymentPollStatus.paid, transaction: tx);
      } else if (status == 'CANCELLED') {
        _timer?.cancel();
        state = PaymentCallbackState(status: PaymentPollStatus.cancelled, transaction: tx);
      } else if (status == 'FAILED' || status == 'FAIL' || status == 'FAILD') {
        _timer?.cancel();
        state = PaymentCallbackState(status: PaymentPollStatus.failed, transaction: tx);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final paymentCallbackProvider = StateNotifierProvider.family<PaymentCallbackNotifier, PaymentCallbackState, int>(
  (ref, transactionId) => PaymentCallbackNotifier(transactionId),
);
