// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_service.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BaseServiceCWProxy<T> {
  BaseService<T> adapter(DbAdapter<T> adapter);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseService<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseService<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseService<T> call({
    DbAdapter<T>? adapter,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBaseService.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBaseService.copyWith.fieldName(...)`
class _$BaseServiceCWProxyImpl<T> implements _$BaseServiceCWProxy<T> {
  final BaseService<T> _value;

  const _$BaseServiceCWProxyImpl(this._value);

  @override
  BaseService<T> adapter(DbAdapter<T> adapter) => this(adapter: adapter);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseService<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseService<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseService<T> call({
    Object? adapter = const $CopyWithPlaceholder(),
  }) {
    return BaseService<T>(
      adapter: adapter == const $CopyWithPlaceholder() || adapter == null
          ? _value.adapter
          // ignore: cast_nullable_to_non_nullable
          : adapter as DbAdapter<T>,
    );
  }
}

extension $BaseServiceCopyWith<T> on BaseService<T> {
  /// Returns a callable class that can be used as follows: `instanceOfBaseService.copyWith(...)` or like so:`instanceOfBaseService.copyWith.fieldName(...)`.
  _$BaseServiceCWProxy<T> get copyWith => _$BaseServiceCWProxyImpl<T>(this);
}
