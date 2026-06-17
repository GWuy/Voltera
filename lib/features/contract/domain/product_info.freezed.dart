// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ProductInfo _$ProductInfoFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'vehicle':
          return VehicleInfo.fromJson(
            json
          );
                case 'battery':
          return BatteryInfo.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ProductInfo',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ProductInfo {

 String get name; double get price;
/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInfoCopyWith<ProductInfo> get copyWith => _$ProductInfoCopyWithImpl<ProductInfo>(this as ProductInfo, _$identity);

  /// Serializes this ProductInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price);

@override
String toString() {
  return 'ProductInfo(name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class $ProductInfoCopyWith<$Res>  {
  factory $ProductInfoCopyWith(ProductInfo value, $Res Function(ProductInfo) _then) = _$ProductInfoCopyWithImpl;
@useResult
$Res call({
 String name, double price
});




}
/// @nodoc
class _$ProductInfoCopyWithImpl<$Res>
    implements $ProductInfoCopyWith<$Res> {
  _$ProductInfoCopyWithImpl(this._self, this._then);

  final ProductInfo _self;
  final $Res Function(ProductInfo) _then;

/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInfo].
extension ProductInfoPatterns on ProductInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VehicleInfo value)?  vehicle,TResult Function( BatteryInfo value)?  battery,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VehicleInfo() when vehicle != null:
return vehicle(_that);case BatteryInfo() when battery != null:
return battery(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VehicleInfo value)  vehicle,required TResult Function( BatteryInfo value)  battery,}){
final _that = this;
switch (_that) {
case VehicleInfo():
return vehicle(_that);case BatteryInfo():
return battery(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VehicleInfo value)?  vehicle,TResult? Function( BatteryInfo value)?  battery,}){
final _that = this;
switch (_that) {
case VehicleInfo() when vehicle != null:
return vehicle(_that);case BatteryInfo() when battery != null:
return battery(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  String brand,  String model,  String version,  int yearManufacture,  double batteryCapacity,  int odo,  String color,  double price)?  vehicle,TResult Function( String name,  String serialNumber,  double originalCapacity,  double remainingCapacity,  double voltage,  int cycleCount,  String warranty,  int mileageCovered,  double price)?  battery,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VehicleInfo() when vehicle != null:
return vehicle(_that.name,_that.brand,_that.model,_that.version,_that.yearManufacture,_that.batteryCapacity,_that.odo,_that.color,_that.price);case BatteryInfo() when battery != null:
return battery(_that.name,_that.serialNumber,_that.originalCapacity,_that.remainingCapacity,_that.voltage,_that.cycleCount,_that.warranty,_that.mileageCovered,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  String brand,  String model,  String version,  int yearManufacture,  double batteryCapacity,  int odo,  String color,  double price)  vehicle,required TResult Function( String name,  String serialNumber,  double originalCapacity,  double remainingCapacity,  double voltage,  int cycleCount,  String warranty,  int mileageCovered,  double price)  battery,}) {final _that = this;
switch (_that) {
case VehicleInfo():
return vehicle(_that.name,_that.brand,_that.model,_that.version,_that.yearManufacture,_that.batteryCapacity,_that.odo,_that.color,_that.price);case BatteryInfo():
return battery(_that.name,_that.serialNumber,_that.originalCapacity,_that.remainingCapacity,_that.voltage,_that.cycleCount,_that.warranty,_that.mileageCovered,_that.price);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  String brand,  String model,  String version,  int yearManufacture,  double batteryCapacity,  int odo,  String color,  double price)?  vehicle,TResult? Function( String name,  String serialNumber,  double originalCapacity,  double remainingCapacity,  double voltage,  int cycleCount,  String warranty,  int mileageCovered,  double price)?  battery,}) {final _that = this;
switch (_that) {
case VehicleInfo() when vehicle != null:
return vehicle(_that.name,_that.brand,_that.model,_that.version,_that.yearManufacture,_that.batteryCapacity,_that.odo,_that.color,_that.price);case BatteryInfo() when battery != null:
return battery(_that.name,_that.serialNumber,_that.originalCapacity,_that.remainingCapacity,_that.voltage,_that.cycleCount,_that.warranty,_that.mileageCovered,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class VehicleInfo implements ProductInfo {
  const VehicleInfo({required this.name, required this.brand, required this.model, required this.version, required this.yearManufacture, required this.batteryCapacity, required this.odo, required this.color, required this.price, final  String? $type}): $type = $type ?? 'vehicle';
  factory VehicleInfo.fromJson(Map<String, dynamic> json) => _$VehicleInfoFromJson(json);

@override final  String name;
 final  String brand;
 final  String model;
 final  String version;
 final  int yearManufacture;
 final  double batteryCapacity;
 final  int odo;
 final  String color;
@override final  double price;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<VehicleInfo> get copyWith => _$VehicleInfoCopyWithImpl<VehicleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.version, version) || other.version == version)&&(identical(other.yearManufacture, yearManufacture) || other.yearManufacture == yearManufacture)&&(identical(other.batteryCapacity, batteryCapacity) || other.batteryCapacity == batteryCapacity)&&(identical(other.odo, odo) || other.odo == odo)&&(identical(other.color, color) || other.color == color)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,brand,model,version,yearManufacture,batteryCapacity,odo,color,price);

@override
String toString() {
  return 'ProductInfo.vehicle(name: $name, brand: $brand, model: $model, version: $version, yearManufacture: $yearManufacture, batteryCapacity: $batteryCapacity, odo: $odo, color: $color, price: $price)';
}


}

/// @nodoc
abstract mixin class $VehicleInfoCopyWith<$Res> implements $ProductInfoCopyWith<$Res> {
  factory $VehicleInfoCopyWith(VehicleInfo value, $Res Function(VehicleInfo) _then) = _$VehicleInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String brand, String model, String version, int yearManufacture, double batteryCapacity, int odo, String color, double price
});




}
/// @nodoc
class _$VehicleInfoCopyWithImpl<$Res>
    implements $VehicleInfoCopyWith<$Res> {
  _$VehicleInfoCopyWithImpl(this._self, this._then);

  final VehicleInfo _self;
  final $Res Function(VehicleInfo) _then;

/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? brand = null,Object? model = null,Object? version = null,Object? yearManufacture = null,Object? batteryCapacity = null,Object? odo = null,Object? color = null,Object? price = null,}) {
  return _then(VehicleInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,yearManufacture: null == yearManufacture ? _self.yearManufacture : yearManufacture // ignore: cast_nullable_to_non_nullable
as int,batteryCapacity: null == batteryCapacity ? _self.batteryCapacity : batteryCapacity // ignore: cast_nullable_to_non_nullable
as double,odo: null == odo ? _self.odo : odo // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BatteryInfo implements ProductInfo {
  const BatteryInfo({required this.name, required this.serialNumber, required this.originalCapacity, required this.remainingCapacity, required this.voltage, required this.cycleCount, required this.warranty, required this.mileageCovered, required this.price, final  String? $type}): $type = $type ?? 'battery';
  factory BatteryInfo.fromJson(Map<String, dynamic> json) => _$BatteryInfoFromJson(json);

@override final  String name;
 final  String serialNumber;
 final  double originalCapacity;
 final  double remainingCapacity;
 final  double voltage;
 final  int cycleCount;
 final  String warranty;
 final  int mileageCovered;
@override final  double price;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatteryInfoCopyWith<BatteryInfo> get copyWith => _$BatteryInfoCopyWithImpl<BatteryInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatteryInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatteryInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.originalCapacity, originalCapacity) || other.originalCapacity == originalCapacity)&&(identical(other.remainingCapacity, remainingCapacity) || other.remainingCapacity == remainingCapacity)&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.cycleCount, cycleCount) || other.cycleCount == cycleCount)&&(identical(other.warranty, warranty) || other.warranty == warranty)&&(identical(other.mileageCovered, mileageCovered) || other.mileageCovered == mileageCovered)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,serialNumber,originalCapacity,remainingCapacity,voltage,cycleCount,warranty,mileageCovered,price);

@override
String toString() {
  return 'ProductInfo.battery(name: $name, serialNumber: $serialNumber, originalCapacity: $originalCapacity, remainingCapacity: $remainingCapacity, voltage: $voltage, cycleCount: $cycleCount, warranty: $warranty, mileageCovered: $mileageCovered, price: $price)';
}


}

/// @nodoc
abstract mixin class $BatteryInfoCopyWith<$Res> implements $ProductInfoCopyWith<$Res> {
  factory $BatteryInfoCopyWith(BatteryInfo value, $Res Function(BatteryInfo) _then) = _$BatteryInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String serialNumber, double originalCapacity, double remainingCapacity, double voltage, int cycleCount, String warranty, int mileageCovered, double price
});




}
/// @nodoc
class _$BatteryInfoCopyWithImpl<$Res>
    implements $BatteryInfoCopyWith<$Res> {
  _$BatteryInfoCopyWithImpl(this._self, this._then);

  final BatteryInfo _self;
  final $Res Function(BatteryInfo) _then;

/// Create a copy of ProductInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? serialNumber = null,Object? originalCapacity = null,Object? remainingCapacity = null,Object? voltage = null,Object? cycleCount = null,Object? warranty = null,Object? mileageCovered = null,Object? price = null,}) {
  return _then(BatteryInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,originalCapacity: null == originalCapacity ? _self.originalCapacity : originalCapacity // ignore: cast_nullable_to_non_nullable
as double,remainingCapacity: null == remainingCapacity ? _self.remainingCapacity : remainingCapacity // ignore: cast_nullable_to_non_nullable
as double,voltage: null == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as double,cycleCount: null == cycleCount ? _self.cycleCount : cycleCount // ignore: cast_nullable_to_non_nullable
as int,warranty: null == warranty ? _self.warranty : warranty // ignore: cast_nullable_to_non_nullable
as String,mileageCovered: null == mileageCovered ? _self.mileageCovered : mileageCovered // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
