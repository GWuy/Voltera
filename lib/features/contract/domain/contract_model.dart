import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_info.dart';
import 'user_info.dart';

part 'contract_model.freezed.dart';
part 'contract_model.g.dart';

enum ContractStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('SIGNED')
  signed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('COMPLETED')
  completed,
}

@freezed
abstract class ContractModel with _$ContractModel {
  const factory ContractModel({
    required String id,
    required int transactionId,
    required DateTime createdAt,
    required ContractStatus status,
    required UserInfo seller,
    required UserInfo buyer,
    required ProductInfo product,
    required double salePrice,
    required bool signedBySeller,
    required bool signedByBuyer,
  }) = _ContractModel;

  factory ContractModel.fromJson(Map<String, dynamic> json) => _$ContractModelFromJson(json);
}
