import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';

class PaymentFailedScreen extends StatelessWidget {
  final int transactionId;
  final String status;

  const PaymentFailedScreen({
    super.key,
    required this.transactionId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = status.toUpperCase() == 'CANCELLED';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.orange.shade50 : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCancelled ? Icons.cancel_rounded : Icons.error_rounded,
                  color: isCancelled ? Colors.orange : Colors.red,
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isCancelled ? 'Payment Cancelled' : 'Payment Failed',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                isCancelled
                    ? 'You cancelled the payment. Your transaction has not been processed.'
                    : 'Something went wrong with your payment. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go(RouteNames.home),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3D3DC6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Go Back', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
