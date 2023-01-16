// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_adapter_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DbAdapterStateCWProxy {
  DbAdapterState bypassLocal(bool bypassLocal);

  DbAdapterState bypassRemote(bool bypassRemote);

  DbAdapterState isOnline(bool isOnline);

  DbAdapterState localDb(LocalDb<dynamic>? localDb);

  DbAdapterState remoteRepo(RemoteRepo<dynamic>? remoteRepo);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DbAdapterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DbAdapterState(...).copyWith(id: 12, name: "My name")
  /// ````
  DbAdapterState call({
    bool? bypassLocal,
    bool? bypassRemote,
    bool? isOnline,
    LocalDb<dynamic>? localDb,
    RemoteRepo<dynamic>? remoteRepo,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDbAdapterState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDbAdapterState.copyWith.fieldName(...)`
class _$DbAdapterStateCWProxyImpl implements _$DbAdapterStateCWProxy {
  final DbAdapterState _value;

  const _$DbAdapterStateCWProxyImpl(this._value);

  @override
  DbAdapterState bypassLocal(bool bypassLocal) =>
      this(bypassLocal: bypassLocal);

  @override
  DbAdapterState bypassRemote(bool bypassRemote) =>
      this(bypassRemote: bypassRemote);

  @override
  DbAdapterState isOnline(bool isOnline) => this(isOnline: isOnline);

  @override
  DbAdapterState localDb(LocalDb<dynamic>? localDb) => this(localDb: localDb);

  @override
  DbAdapterState remoteRepo(RemoteRepo<dynamic>? remoteRepo) =>
      this(remoteRepo: remoteRepo);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DbAdapterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DbAdapterState(...).copyWith(id: 12, name: "My name")
  /// ````
  DbAdapterState call({
    Object? bypassLocal = const $CopyWithPlaceholder(),
    Object? bypassRemote = const $CopyWithPlaceholder(),
    Object? isOnline = const $CopyWithPlaceholder(),
    Object? localDb = const $CopyWithPlaceholder(),
    Object? remoteRepo = const $CopyWithPlaceholder(),
  }) {
    return DbAdapterState(
      bypassLocal:
          bypassLocal == const $CopyWithPlaceholder() || bypassLocal == null
              ? _value.bypassLocal
              // ignore: cast_nullable_to_non_nullable
              : bypassLocal as bool,
      bypassRemote:
          bypassRemote == const $CopyWithPlaceholder() || bypassRemote == null
              ? _value.bypassRemote
              // ignore: cast_nullable_to_non_nullable
              : bypassRemote as bool,
      isOnline: isOnline == const $CopyWithPlaceholder() || isOnline == null
          ? _value.isOnline
          // ignore: cast_nullable_to_non_nullable
          : isOnline as bool,
      localDb: localDb == const $CopyWithPlaceholder()
          ? _value.localDb
          // ignore: cast_nullable_to_non_nullable
          : localDb as LocalDb<dynamic>?,
      remoteRepo: remoteRepo == const $CopyWithPlaceholder()
          ? _value.remoteRepo
          // ignore: cast_nullable_to_non_nullable
          : remoteRepo as RemoteRepo<dynamic>?,
    );
  }
}

extension $DbAdapterStateCopyWith on DbAdapterState {
  /// Returns a callable class that can be used as follows: `instanceOfDbAdapterState.copyWith(...)` or like so:`instanceOfDbAdapterState.copyWith.fieldName(...)`.
  _$DbAdapterStateCWProxy get copyWith => _$DbAdapterStateCWProxyImpl(this);
}
