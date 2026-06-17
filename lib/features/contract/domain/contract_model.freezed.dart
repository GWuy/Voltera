// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contract_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContractModel {

 String get id; DateTime get createdAt; ContractStatus get status; UserInfo get seller; UserInfo get buyer; ProductInfo get product; double get salePrice; bool get signedBySeller; bool get signedByBuyer;
/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractModelCopyWith<ContractModel> get copyWith => _$ContractModelCopyWithImpl<ContractModel>(this as ContractModel, _$identity);

  /// Serializes this ContractModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.product, product) || other.product == product)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.signedBySeller, signedBySeller) || other.signedBySeller == signedBySeller)&&(identical(other.signedByBuyer, signedByBuyer) || other.signedByBuyer == signedByBuyer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,seller,buyer,product,salePrice,signedBySeller,signedByBuyer);

@override
String toString() {
  return 'ContractModel(id: $id, createdAt: $createdAt, status: $status, seller: $seller, buyer: $buyer, product: $product, salePrice: $salePrice, signedBySeller: $signedBySeller, signedByBuyer: $signedByBuyer)';
}


}

/// @nodoc
abstract mixin class $ContractModelCopyWith<$Res>  {
  factory $ContractModelCopyWith(ContractModel value, $Res Function(ContractModel) _then) = _$ContractModelCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, ContractStatus status, UserInfo seller, UserInfo buyer, ProductInfo product, double salePrice, bool signedBySeller, bool signedByBuyer
});


$UserInfoCopyWith<$Res> get seller;$UserInfoCopyWith<$Res> get buyer;$ProductInfoCopyWith<$Res> get product;

}
/// @nodoc
class _$ContractModelCopyWithImpl<$Res>
    implements $ContractModelCopyWith<$Res> {
  _$ContractModelCopyWithImpl(this._self, this._then);

  final ContractModel _self;
  final $Res Function(ContractModel) _then;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? status = null,Object? seller = null,Object? buyer = null,Object? product = null,Object? salePrice = null,Object? signedBySeller = null,Object? signedByBuyer = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContractStatus,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as UserInfo,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as UserInfo,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductInfo,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,signedBySeller: null == signedBySeller ? _self.signedBySeller : signedBySeller // ignore: cast_nullable_to_non_nullable
as bool,signedByBuyer: null == signedByBuyer ? _self.signedByBuyer : signedByBuyer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get seller {
  
  return $UserInfoCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get buyer {
  
  return $UserInfoCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductInfoCopyWith<$Res> get product {
  
  return $ProductInfoCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContractModel].
extension ContractModelPatterns on ContractModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractModel value)  $default,){
final _that = this;
switch (_that) {
case _ContractModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractModel value)?  $default,){
final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  ContractStatus status,  UserInfo seller,  UserInfo buyer,  ProductInfo product,  double salePrice,  bool signedBySeller,  bool signedByBuyer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.seller,_that.buyer,_that.product,_that.salePrice,_that.signedBySeller,_that.signedByBuyer);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  ContractStatus status,  UserInfo seller,  UserInfo buyer,  ProductInfo product,  double salePrice,  bool signedBySeller,  bool signedByBuyer)  $default,) {final _that = this;
switch (_that) {
case _ContractModel():
return $default(_that.id,_that.createdAt,_that.status,_that.seller,_that.buyer,_that.product,_that.salePrice,_that.signedBySeller,_that.signedByBuyer);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  ContractStatus status,  UserInfo seller,  UserInfo buyer,  ProductInfo product,  double salePrice,  bool signedBySeller,  bool signedByBuyer)?  $default,) {final _that = this;
switch (_that) {
case _ContractModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.seller,_that.buyer,_that.product,_that.salePrice,_that.signedBySeller,_that.signedByBuyer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractModel implements ContractModel {
  const _ContractModel({required this.id, required this.createdAt, required this.status, required this.seller, required this.buyer, required this.product, required this.salePrice, required this.signedBySeller, required this.signedByBuyer});
  factory _ContractModel.fromJson(Map<String, dynamic> json) => _$ContractModelFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  ContractStatus status;
@override final  UserInfo seller;
@override final  UserInfo buyer;
@override final  ProductInfo product;
@override final  double salePrice;
@override final  bool signedBySeller;
@override final  bool signedByBuyer;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractModelCopyWith<_ContractModel> get copyWith => __$ContractModelCopyWithImpl<_ContractModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.product, product) || other.product == product)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.signedBySeller, signedBySeller) || other.signedBySeller == signedBySeller)&&(identical(other.signedByBuyer, signedByBuyer) || other.signedByBuyer == signedByBuyer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,seller,buyer,product,salePrice,signedBySeller,signedByBuyer);

@override
String toString() {
  return 'ContractModel(id: $id, createdAt: $createdAt, status: $status, seller: $seller, buyer: $buyer, product: $product, salePrice: $salePrice, signedBySeller: $signedBySeller, signedByBuyer: $signedByBuyer)';
}


}

/// @nodoc
abstract mixin class _$ContractModelCopyWith<$Res> implements $ContractModelCopyWith<$Res> {
  factory _$ContractModelCopyWith(_ContractModel value, $Res Function(_ContractModel) _then) = __$ContractModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, ContractStatus status, UserInfo seller, UserInfo buyer, ProductInfo product, double salePrice, bool signedBySeller, bool signedByBuyer
});


@override $UserInfoCopyWith<$Res> get seller;@override $UserInfoCopyWith<$Res> get buyer;@override $ProductInfoCopyWith<$Res> get product;

}
/// @nodoc
class __$ContractModelCopyWithImpl<$Res>
    implements _$ContractModelCopyWith<$Res> {
  __$ContractModelCopyWithImpl(this._self, this._then);

  final _ContractModel _self;
  final $Res Function(_ContractModel) _then;

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? status = null,Object? seller = null,Object? buyer = null,Object? product = null,Object? salePrice = null,Object? signedBySeller = null,Object? signedByBuyer = null,}) {
  return _then(_ContractModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContractStatus,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as UserInfo,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as UserInfo,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductInfo,salePrice: null == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double,signedBySeller: null == signedBySeller ? _self.signedBySeller : signedBySeller // ignore: cast_nullable_to_non_nullable
as bool,signedByBuyer: null == signedByBuyer ? _self.signedByBuyer : signedByBuyer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get seller {
  
  return $UserInfoCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get buyer {
  
  return $UserInfoCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of ContractModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductInfoCopyWith<$Res> get product {
  
  return $ProductInfoCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
