// // GENERATED CODE - DO NOT MODIFY BY HAND
// // coverage:ignore-file
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
//
// part of 'payment_model.dart';
//
// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************
//
// // dart format off
// T _$identity<T>(T value) => value;
//
// /// @nodoc
// mixin _$PayOSCreateResponse {
//
//  String get checkoutUrl; String get paymentLinkId; int get orderCode; int get transactionId;
// /// Create a copy of PayOSCreateResponse
// /// with the given fields replaced by the non-null parameter values.
// @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// $PayOSCreateResponseCopyWith<PayOSCreateResponse> get copyWith => _$PayOSCreateResponseCopyWithImpl<PayOSCreateResponse>(this as PayOSCreateResponse, _$identity);
//
//   /// Serializes this PayOSCreateResponse to a JSON map.
//   Map<String, dynamic> toJson();
//
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is PayOSCreateResponse&&(identical(other.checkoutUrl, checkoutUrl) || other.checkoutUrl == checkoutUrl)&&(identical(other.paymentLinkId, paymentLinkId) || other.paymentLinkId == paymentLinkId)&&(identical(other.orderCode, orderCode) || other.orderCode == orderCode)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,checkoutUrl,paymentLinkId,orderCode,transactionId);
//
// @override
// String toString() {
//   return 'PayOSCreateResponse(checkoutUrl: $checkoutUrl, paymentLinkId: $paymentLinkId, orderCode: $orderCode, transactionId: $transactionId)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class $PayOSCreateResponseCopyWith<$Res>  {
//   factory $PayOSCreateResponseCopyWith(PayOSCreateResponse value, $Res Function(PayOSCreateResponse) _then) = _$PayOSCreateResponseCopyWithImpl;
// @useResult
// $Res call({
//  String checkoutUrl, String paymentLinkId, int orderCode, int transactionId
// });
//
//
//
//
// }
// /// @nodoc
// class _$PayOSCreateResponseCopyWithImpl<$Res>
//     implements $PayOSCreateResponseCopyWith<$Res> {
//   _$PayOSCreateResponseCopyWithImpl(this._self, this._then);
//
//   final PayOSCreateResponse _self;
//   final $Res Function(PayOSCreateResponse) _then;
//
// /// Create a copy of PayOSCreateResponse
// /// with the given fields replaced by the non-null parameter values.
// @pragma('vm:prefer-inline') @override $Res call({Object? checkoutUrl = null,Object? paymentLinkId = null,Object? orderCode = null,Object? transactionId = null,}) {
//   return _then(_self.copyWith(
// checkoutUrl: null == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
// as String,paymentLinkId: null == paymentLinkId ? _self.paymentLinkId : paymentLinkId // ignore: cast_nullable_to_non_nullable
// as String,orderCode: null == orderCode ? _self.orderCode : orderCode // ignore: cast_nullable_to_non_nullable
// as int,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
// as int,
//   ));
// }
//
// }
//
//
// /// Adds pattern-matching-related methods to [PayOSCreateResponse].
// extension PayOSCreateResponsePatterns on PayOSCreateResponse {
// /// A variant of `map` that fallback to returning `orElse`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```
//
// @optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayOSCreateResponse value)?  $default,{required TResult orElse(),}){
// final _that = this;
// switch (_that) {
// case _PayOSCreateResponse() when $default != null:
// return $default(_that);case _:
//   return orElse();
//
// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// Callbacks receives the raw object, upcasted.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case final Subclass2 value:
// ///     return ...;
// /// }
// /// ```
//
// @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayOSCreateResponse value)  $default,){
// final _that = this;
// switch (_that) {
// case _PayOSCreateResponse():
// return $default(_that);case _:
//   throw StateError('Unexpected subclass');
//
// }
// }
// /// A variant of `map` that fallback to returning `null`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```
//
// @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayOSCreateResponse value)?  $default,){
// final _that = this;
// switch (_that) {
// case _PayOSCreateResponse() when $default != null:
// return $default(_that);case _:
//   return null;
//
// }
// }
// /// A variant of `when` that fallback to an `orElse` callback.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```
//
// @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String checkoutUrl,  String paymentLinkId,  int orderCode,  int transactionId)?  $default,{required TResult orElse(),}) {final _that = this;
// switch (_that) {
// case _PayOSCreateResponse() when $default != null:
// return $default(_that.checkoutUrl,_that.paymentLinkId,_that.orderCode,_that.transactionId);case _:
//   return orElse();
//
// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// As opposed to `map`, this offers destructuring.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case Subclass2(:final field2):
// ///     return ...;
// /// }
// /// ```
//
// @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String checkoutUrl,  String paymentLinkId,  int orderCode,  int transactionId)  $default,) {final _that = this;
// switch (_that) {
// case _PayOSCreateResponse():
// return $default(_that.checkoutUrl,_that.paymentLinkId,_that.orderCode,_that.transactionId);case _:
//   throw StateError('Unexpected subclass');
//
// }
// }
// /// A variant of `when` that fallback to returning `null`
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```
//
// @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String checkoutUrl,  String paymentLinkId,  int orderCode,  int transactionId)?  $default,) {final _that = this;
// switch (_that) {
// case _PayOSCreateResponse() when $default != null:
// return $default(_that.checkoutUrl,_that.paymentLinkId,_that.orderCode,_that.transactionId);case _:
//   return null;
//
// }
// }
//
// }
//
// /// @nodoc
// @JsonSerializable()
//
// class _PayOSCreateResponse implements PayOSCreateResponse {
//   const _PayOSCreateResponse({required this.checkoutUrl, required this.paymentLinkId, required this.orderCode, required this.transactionId});
//   factory _PayOSCreateResponse.fromJson(Map<String, dynamic> json) => _$PayOSCreateResponseFromJson(json);
//
// @override final  String checkoutUrl;
// @override final  String paymentLinkId;
// @override final  int orderCode;
// @override final  int transactionId;
//
// /// Create a copy of PayOSCreateResponse
// /// with the given fields replaced by the non-null parameter values.
// @override @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// _$PayOSCreateResponseCopyWith<_PayOSCreateResponse> get copyWith => __$PayOSCreateResponseCopyWithImpl<_PayOSCreateResponse>(this, _$identity);
//
// @override
// Map<String, dynamic> toJson() {
//   return _$PayOSCreateResponseToJson(this, );
// }
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayOSCreateResponse&&(identical(other.checkoutUrl, checkoutUrl) || other.checkoutUrl == checkoutUrl)&&(identical(other.paymentLinkId, paymentLinkId) || other.paymentLinkId == paymentLinkId)&&(identical(other.orderCode, orderCode) || other.orderCode == orderCode)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,checkoutUrl,paymentLinkId,orderCode,transactionId);
//
// @override
// String toString() {
//   return 'PayOSCreateResponse(checkoutUrl: $checkoutUrl, paymentLinkId: $paymentLinkId, orderCode: $orderCode, transactionId: $transactionId)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class _$PayOSCreateResponseCopyWith<$Res> implements $PayOSCreateResponseCopyWith<$Res> {
//   factory _$PayOSCreateResponseCopyWith(_PayOSCreateResponse value, $Res Function(_PayOSCreateResponse) _then) = __$PayOSCreateResponseCopyWithImpl;
// @override @useResult
// $Res call({
//  String checkoutUrl, String paymentLinkId, int orderCode, int transactionId
// });
//
//
//
//
// }
// /// @nodoc
// class __$PayOSCreateResponseCopyWithImpl<$Res>
//     implements _$PayOSCreateResponseCopyWith<$Res> {
//   __$PayOSCreateResponseCopyWithImpl(this._self, this._then);
//
//   final _PayOSCreateResponse _self;
//   final $Res Function(_PayOSCreateResponse) _then;
//
// /// Create a copy of PayOSCreateResponse
// /// with the given fields replaced by the non-null parameter values.
// @override @pragma('vm:prefer-inline') $Res call({Object? checkoutUrl = null,Object? paymentLinkId = null,Object? orderCode = null,Object? transactionId = null,}) {
//   return _then(_PayOSCreateResponse(
// checkoutUrl: null == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
// as String,paymentLinkId: null == paymentLinkId ? _self.paymentLinkId : paymentLinkId // ignore: cast_nullable_to_non_nullable
// as String,orderCode: null == orderCode ? _self.orderCode : orderCode // ignore: cast_nullable_to_non_nullable
// as int,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
// as int,
//   ));
// }
//
//
// }
//
//
// /// @nodoc
// mixin _$TransactionStatusResponse {
//
//  int get transactionId; String get transactionStatus;
// /// Create a copy of TransactionStatusResponse
// /// with the given fields replaced by the non-null parameter values.
// @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// $TransactionStatusResponseCopyWith<TransactionStatusResponse> get copyWith => _$TransactionStatusResponseCopyWithImpl<TransactionStatusResponse>(this as TransactionStatusResponse, _$identity);
//
//   /// Serializes this TransactionStatusResponse to a JSON map.
//   Map<String, dynamic> toJson();
//
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionStatusResponse&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.transactionStatus, transactionStatus) || other.transactionStatus == transactionStatus));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,transactionId,transactionStatus);
//
// @override
// String toString() {
//   return 'TransactionStatusResponse(transactionId: $transactionId, transactionStatus: $transactionStatus)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class $TransactionStatusResponseCopyWith<$Res>  {
//   factory $TransactionStatusResponseCopyWith(TransactionStatusResponse value, $Res Function(TransactionStatusResponse) _then) = _$TransactionStatusResponseCopyWithImpl;
// @useResult
// $Res call({
//  int transactionId, String transactionStatus
// });
//
//
//
//
// }
// /// @nodoc
// class _$TransactionStatusResponseCopyWithImpl<$Res>
//     implements $TransactionStatusResponseCopyWith<$Res> {
//   _$TransactionStatusResponseCopyWithImpl(this._self, this._then);
//
//   final TransactionStatusResponse _self;
//   final $Res Function(TransactionStatusResponse) _then;
//
// /// Create a copy of TransactionStatusResponse
// /// with the given fields replaced by the non-null parameter values.
// @pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? transactionStatus = null,}) {
//   return _then(_self.copyWith(
// transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
// as int,transactionStatus: null == transactionStatus ? _self.transactionStatus : transactionStatus // ignore: cast_nullable_to_non_nullable
// as String,
//   ));
// }
//
// }
//
//
// /// Adds pattern-matching-related methods to [TransactionStatusResponse].
// extension TransactionStatusResponsePatterns on TransactionStatusResponse {
// /// A variant of `map` that fallback to returning `orElse`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```
//
// @optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionStatusResponse value)?  $default,{required TResult orElse(),}){
// final _that = this;
// switch (_that) {
// case _TransactionStatusResponse() when $default != null:
// return $default(_that);case _:
//   return orElse();
//
// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// Callbacks receives the raw object, upcasted.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case final Subclass2 value:
// ///     return ...;
// /// }
// /// ```
//
// @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionStatusResponse value)  $default,){
// final _that = this;
// switch (_that) {
// case _TransactionStatusResponse():
// return $default(_that);case _:
//   throw StateError('Unexpected subclass');
//
// }
// }
// /// A variant of `map` that fallback to returning `null`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```
//
// @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionStatusResponse value)?  $default,){
// final _that = this;
// switch (_that) {
// case _TransactionStatusResponse() when $default != null:
// return $default(_that);case _:
//   return null;
//
// }
// }
// /// A variant of `when` that fallback to an `orElse` callback.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```
//
// @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transactionId,  String transactionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
// switch (_that) {
// case _TransactionStatusResponse() when $default != null:
// return $default(_that.transactionId,_that.transactionStatus);case _:
//   return orElse();
//
// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// As opposed to `map`, this offers destructuring.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case Subclass2(:final field2):
// ///     return ...;
// /// }
// /// ```
//
// @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transactionId,  String transactionStatus)  $default,) {final _that = this;
// switch (_that) {
// case _TransactionStatusResponse():
// return $default(_that.transactionId,_that.transactionStatus);case _:
//   throw StateError('Unexpected subclass');
//
// }
// }
// /// A variant of `when` that fallback to returning `null`
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```
//
// @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transactionId,  String transactionStatus)?  $default,) {final _that = this;
// switch (_that) {
// case _TransactionStatusResponse() when $default != null:
// return $default(_that.transactionId,_that.transactionStatus);case _:
//   return null;
//
// }
// }
//
// }
//
// /// @nodoc
// @JsonSerializable()
//
// class _TransactionStatusResponse implements TransactionStatusResponse {
//   const _TransactionStatusResponse({required this.transactionId, required this.transactionStatus});
//   factory _TransactionStatusResponse.fromJson(Map<String, dynamic> json) => _$TransactionStatusResponseFromJson(json);
//
// @override final  int transactionId;
// @override final  String transactionStatus;
//
// /// Create a copy of TransactionStatusResponse
// /// with the given fields replaced by the non-null parameter values.
// @override @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// _$TransactionStatusResponseCopyWith<_TransactionStatusResponse> get copyWith => __$TransactionStatusResponseCopyWithImpl<_TransactionStatusResponse>(this, _$identity);
//
// @override
// Map<String, dynamic> toJson() {
//   return _$TransactionStatusResponseToJson(this, );
// }
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionStatusResponse&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.transactionStatus, transactionStatus) || other.transactionStatus == transactionStatus));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,transactionId,transactionStatus);
//
// @override
// String toString() {
//   return 'TransactionStatusResponse(transactionId: $transactionId, transactionStatus: $transactionStatus)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class _$TransactionStatusResponseCopyWith<$Res> implements $TransactionStatusResponseCopyWith<$Res> {
//   factory _$TransactionStatusResponseCopyWith(_TransactionStatusResponse value, $Res Function(_TransactionStatusResponse) _then) = __$TransactionStatusResponseCopyWithImpl;
// @override @useResult
// $Res call({
//  int transactionId, String transactionStatus
// });
//
//
//
//
// }
// /// @nodoc
// class __$TransactionStatusResponseCopyWithImpl<$Res>
//     implements _$TransactionStatusResponseCopyWith<$Res> {
//   __$TransactionStatusResponseCopyWithImpl(this._self, this._then);
//
//   final _TransactionStatusResponse _self;
//   final $Res Function(_TransactionStatusResponse) _then;
//
// /// Create a copy of TransactionStatusResponse
// /// with the given fields replaced by the non-null parameter values.
// @override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? transactionStatus = null,}) {
//   return _then(_TransactionStatusResponse(
// transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
// as int,transactionStatus: null == transactionStatus ? _self.transactionStatus : transactionStatus // ignore: cast_nullable_to_non_nullable
// as String,
//   ));
// }
//
//
// }
//
// // dart format on
