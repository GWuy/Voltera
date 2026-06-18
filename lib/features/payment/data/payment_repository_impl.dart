// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/network/api_client.dart';
// import '../domain/payment_model.dart';
//
// abstract class PaymentRepository {
//   Future<PayOSCreateResponse> createPayOSPayment(int transactionId, double amount, String orderInfo);
//   Future<TransactionStatusResponse> getTransactionStatus(int transactionId);
// }
//
// class PaymentRepositoryImpl implements PaymentRepository {
//   final _dio = ApiClient.instance.dio;
//
//   @override
//   Future<PayOSCreateResponse> createPayOSPayment(int transactionId, double amount, String orderInfo) async {
//     final response = await _dio.post(
//       '/api/payos/create-payment/$transactionId',
//       data: {
//         'amount': amount,
//         'orderInfo': orderInfo,
//       },
//     );
//     return PayOSCreateResponse.fromJson(response.data);
//   }
//
//   @override
//   Future<TransactionStatusResponse> getTransactionStatus(int transactionId) async {
//     final response = await _dio.get('/api/transactions/status/$transactionId');
//     return TransactionStatusResponse.fromJson(response.data);
//   }
// }
//
// final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
//   return PaymentRepositoryImpl();
// });
