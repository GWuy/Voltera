import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/transaction_repository_impl.dart';
import '../domain/transaction_model.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

class TransactionStatusNotifier extends Notifier<String> {
  @override
  String build() => 'PENDING';

  void setStatus(String status) => state = status;
}

final selectedTransactionStatusProvider = NotifierProvider<TransactionStatusNotifier, String>(() {
  return TransactionStatusNotifier();
});

final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final status = ref.watch(selectedTransactionStatusProvider);
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getTransactionsByStatus(status);
});

final transactionDetailProvider = FutureProvider.family<TransactionModel, int>((ref, id) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getTransactionDetail(id);
});
