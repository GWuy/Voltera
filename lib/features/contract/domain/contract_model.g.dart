// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    _ContractModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecode(_$ContractStatusEnumMap, json['status']),
      seller: UserInfo.fromJson(json['seller'] as Map<String, dynamic>),
      buyer: UserInfo.fromJson(json['buyer'] as Map<String, dynamic>),
      product: ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
      salePrice: (json['salePrice'] as num).toDouble(),
      signedBySeller: json['signedBySeller'] as bool,
      signedByBuyer: json['signedByBuyer'] as bool,
    );

Map<String, dynamic> _$ContractModelToJson(_ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ContractStatusEnumMap[instance.status]!,
      'seller': instance.seller,
      'buyer': instance.buyer,
      'product': instance.product,
      'salePrice': instance.salePrice,
      'signedBySeller': instance.signedBySeller,
      'signedByBuyer': instance.signedByBuyer,
    };

const _$ContractStatusEnumMap = {
  ContractStatus.pending: 'PENDING',
  ContractStatus.signed: 'SIGNED',
  ContractStatus.cancelled: 'CANCELLED',
  ContractStatus.completed: 'COMPLETED',
};
