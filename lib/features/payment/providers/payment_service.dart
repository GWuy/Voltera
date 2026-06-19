import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_client.dart';

class PaymentCheckoutResponse {
  final String checkoutUrl;
  final String paymentLinkId;
  final int orderCode;
  final int transactionId;

  PaymentCheckoutResponse({
    required this.checkoutUrl,
    required this.paymentLinkId,
    required this.orderCode,
    required this.transactionId,
  });

  factory PaymentCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      PaymentCheckoutResponse(
        checkoutUrl: json['checkoutUrl'] as String? ?? '',
        paymentLinkId: json['paymentLinkId'] as String? ?? '',
        orderCode: json['orderCode'] as int? ?? 0,
        transactionId: json['transactionId'] as int? ?? 0,
      );
}

class PaymentService {
  final _dio = ApiClient.createPublicDio();

  Future<PaymentCheckoutResponse> createPayment(int transactionId) async {
    final response = await _dio.post(
      '/api/payos/create-payment/$transactionId',
    );
    return PaymentCheckoutResponse.fromJson(response.data);
  }

  Future<String?> createPaymentAndOpen(int transactionId) async {
    final response = await createPayment(transactionId);
    if (response.checkoutUrl.isEmpty) return null;
    final uri = Uri.parse(response.checkoutUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return response.checkoutUrl;
  }
}

final paymentServiceProvider = Provider<PaymentService>(
  (ref) => PaymentService(),
);
