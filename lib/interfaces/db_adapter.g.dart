// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_adapter.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DbAdapterCWProxy<T> {
  DbAdapter<T> fromJson(T Function(Map<String, Object?>?) fromJson);

  DbAdapter<T> hasRemotePriority(bool hasRemotePriority);

  DbAdapter<T> state(DbAdapterState? state);

  DbAdapter<T> tableName(String tableName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DbAdapter<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DbAdapter<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  DbAdapter<T> call({
    T Function(Map<String, Object?>?)? fromJson,
    bool? hasRemotePriority,
    DbAdapterState? state,
    String? tableName,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDbAdapter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDbAdapter.copyWith.fieldName(...)`
class _$DbAdapterCWProxyImpl<T> implements _$DbAdapterCWProxy<T> {
  final DbAdapter<T> _value;

  const _$DbAdapterCWProxyImpl(this._value);

  @override
  DbAdapter<T> fromJson(T Function(Map<String, Object?>?) fromJson) =>
      this(fromJson: fromJson);

  @override
  DbAdapter<T> hasRemotePriority(bool hasRemotePriority) =>
      this(hasRemotePriority: hasRemotePriority);

  @override
  DbAdapter<T> state(DbAdapterState? state) => this(state: state);

  @override
  DbAdapter<T> tableName(String tableName) => this(tableName: tableName);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DbAdapter<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DbAdapter<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  DbAdapter<T> call({
    Object? fromJson = const $CopyWithPlaceholder(),
    Object? hasRemotePriority = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? tableName = const $CopyWithPlaceholder(),
  }) {
    return DbAdapter<T>(
      fromJson: fromJson == const $CopyWithPlaceholder() || fromJson == null
          ? _value.fromJson
          // ignore: cast_nullable_to_non_nullable
          : fromJson as T Function(Map<String, Object?>?),
      hasRemotePriority: hasRemotePriority == const $CopyWithPlaceholder() ||
              hasRemotePriority == null
          ? _value.hasRemotePriority
          // ignore: cast_nullable_to_non_nullable
          : hasRemotePriority as bool,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as DbAdapterState?,
      tableName: tableName == const $CopyWithPlaceholder() || tableName == null
          ? _value.tableName
          // ignore: cast_nullable_to_non_nullable
          : tableName as String,
    );
  }
}

extension $DbAdapterCopyWith<T> on DbAdapter<T> {
  /// Returns a callable class that can be used as follows: `instanceOfDbAdapter.copyWith(...)` or like so:`instanceOfDbAdapter.copyWith.fieldName(...)`.
  _$DbAdapterCWProxy<T> get copyWith => _$DbAdapterCWProxyImpl<T>(this);
}
