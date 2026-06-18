// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../data/payment_repository_impl.dart';
//
// class PaymentService {
//   final Ref ref;
//   PaymentService(this.ref);
//
//   Future<void> startPayment(BuildContext context, int transactionId, double amount, String orderInfo) async {
//     try {
//       final repo = ref.read(paymentRepositoryProvider);
//       final response = await repo.createPayOSPayment(transactionId, amount, orderInfo);
//
//       if (response.code == "00" && response.checkoutUrl.isNotEmpty) {
//         final url = Uri.parse(response.checkoutUrl);
//         if (await canLaunchUrl(url)) {
//           await launchUrl(url, mode: LaunchMode.externalApplication);
//         } else {
//           throw 'Could not launch payment URL';
//         }
//       } else {
//         throw response.message;
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
//
// final paymentServiceProvider = Provider<PaymentService>((ref) => PaymentService(ref));
