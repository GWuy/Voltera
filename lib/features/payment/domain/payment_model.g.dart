// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'payment_model.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// _PayOSCreateResponse _$PayOSCreateResponseFromJson(Map<String, dynamic> json) =>
//     _PayOSCreateResponse(
//       checkoutUrl: json['checkoutUrl'] as String,
//       paymentLinkId: json['paymentLinkId'] as String,
//       orderCode: (json['orderCode'] as num).toInt(),
//       transactionId: (json['transactionId'] as num).toInt(),
//     );
//
// Map<String, dynamic> _$PayOSCreateResponseToJson(
//   _PayOSCreateResponse instance,
// ) => <String, dynamic>{
//   'checkoutUrl': instance.checkoutUrl,
//   'paymentLinkId': instance.paymentLinkId,
//   'orderCode': instance.orderCode,
//   'transactionId': instance.transactionId,
// };
//
// _TransactionStatusResponse _$TransactionStatusResponseFromJson(
//   Map<String, dynamic> json,
// ) => _TransactionStatusResponse(
//   transactionId: (json['transactionId'] as num).toInt(),
//   transactionStatus: json['transactionStatus'] as String,
// );
//
// Map<String, dynamic> _$TransactionStatusResponseToJson(
//   _TransactionStatusResponse instance,
// ) => <String, dynamic>{
//   'transactionId': instance.transactionId,
//   'transactionStatus': instance.transactionStatus,
// };
