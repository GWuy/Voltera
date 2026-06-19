import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../payment/providers/payment_service.dart';
import '../providers/transaction_providers.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(transactionDetailProvider(transactionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        centerTitle: true,
      ),
      body: detailAsync.when(
        data: (tx) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Transaction Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 32),
                  _buildInfoRow('Transaction ID', '#${tx.id}'),
                  _buildInfoRow('Post ID', '#${tx.postId ?? '-'}'),
                  _buildInfoRow('Product', tx.postTitle ?? '-'),
                  _buildInfoRow(
                    'Price',
                    '\$${(tx.price ?? 0).toStringAsFixed(2)}',
                    isBold: true,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Status', tx.transactionStatus ?? '-'),
                  if (tx.createAt != null)
                    _buildInfoRow(
                      'Created At',
                      DateFormat('MMM dd, yyyy - HH:mm').format(tx.createAt!),
                    ),
                  if (tx.updateAt != null)
                    _buildInfoRow(
                      'Updated At',
                      DateFormat('MMM dd, yyyy - HH:mm').format(tx.updateAt!),
                    ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: tx.transactionStatus?.toUpperCase() == 'PAID'
                        ? null
                        : () async {
                            final payment = ref.read(paymentServiceProvider);
                            final checkoutUrl = await payment
                                .createPaymentAndOpen(transactionId);
                            if (context.mounted && checkoutUrl == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cannot open payment'),
                                ),
                              );
                            }
                          },
                    child: const Text('Pay now'),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              TextButton(
                onPressed: () =>
                    ref.invalidate(transactionDetailProvider(transactionId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
