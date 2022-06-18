// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SyncDtoCWProxy {
  SyncDto action(SyncAction action);

  SyncDto id(String? id);

  SyncDto localId(int? localId);

  SyncDto table(String table);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SyncDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SyncDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SyncDto call({
    SyncAction? action,
    String? id,
    int? localId,
    String? table,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSyncDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSyncDto.copyWith.fieldName(...)`
class _$SyncDtoCWProxyImpl implements _$SyncDtoCWProxy {
  final SyncDto _value;

  const _$SyncDtoCWProxyImpl(this._value);

  @override
  SyncDto action(SyncAction action) => this(action: action);

  @override
  SyncDto id(String? id) => this(id: id);

  @override
  SyncDto localId(int? localId) => this(localId: localId);

  @override
  SyncDto table(String table) => this(table: table);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SyncDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SyncDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SyncDto call({
    Object? action = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? localId = const $CopyWithPlaceholder(),
    Object? table = const $CopyWithPlaceholder(),
  }) {
    return SyncDto(
      action: action == const $CopyWithPlaceholder() || action == null
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as SyncAction,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      localId: localId == const $CopyWithPlaceholder()
          ? _value.localId
          // ignore: cast_nullable_to_non_nullable
          : localId as int?,
      table: table == const $CopyWithPlaceholder() || table == null
          ? _value.table
          // ignore: cast_nullable_to_non_nullable
          : table as String,
    );
  }
}

extension $SyncDtoCopyWith on SyncDto {
  /// Returns a callable class that can be used as follows: `instanceOfSyncDto.copyWith(...)` or like so:`instanceOfSyncDto.copyWith.fieldName(...)`.
  _$SyncDtoCWProxy get copyWith => _$SyncDtoCWProxyImpl(this);
}
