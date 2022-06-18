// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ids.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IDsCWProxy {
  IDs id(String? id);

  IDs localId(dynamic localId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IDs(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IDs(...).copyWith(id: 12, name: "My name")
  /// ````
  IDs call({
    String? id,
    dynamic? localId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIDs.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIDs.copyWith.fieldName(...)`
class _$IDsCWProxyImpl implements _$IDsCWProxy {
  final IDs _value;

  const _$IDsCWProxyImpl(this._value);

  @override
  IDs id(String? id) => this(id: id);

  @override
  IDs localId(dynamic localId) => this(localId: localId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IDs(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IDs(...).copyWith(id: 12, name: "My name")
  /// ````
  IDs call({
    Object? id = const $CopyWithPlaceholder(),
    Object? localId = const $CopyWithPlaceholder(),
  }) {
    return IDs(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      localId: localId == const $CopyWithPlaceholder() || localId == null
          ? _value.localId
          // ignore: cast_nullable_to_non_nullable
          : localId as dynamic,
    );
  }
}

extension $IDsCopyWith on IDs {
  /// Returns a callable class that can be used as follows: `instanceOfIDs.copyWith(...)` or like so:`instanceOfIDs.copyWith.fieldName(...)`.
  _$IDsCWProxy get copyWith => _$IDsCWProxyImpl(this);
}
