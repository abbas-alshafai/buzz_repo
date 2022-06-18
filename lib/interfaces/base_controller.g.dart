// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_controller.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BaseControllerCWProxy<T> {
  BaseController<T> service(BaseService<T> service);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseController<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseController<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseController<T> call({
    BaseService<T>? service,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBaseController.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBaseController.copyWith.fieldName(...)`
class _$BaseControllerCWProxyImpl<T> implements _$BaseControllerCWProxy<T> {
  final BaseController<T> _value;

  const _$BaseControllerCWProxyImpl(this._value);

  @override
  BaseController<T> service(BaseService<T> service) => this(service: service);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseController<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseController<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseController<T> call({
    Object? service = const $CopyWithPlaceholder(),
  }) {
    return BaseController<T>(
      service: service == const $CopyWithPlaceholder() || service == null
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as BaseService<T>,
    );
  }
}

extension $BaseControllerCopyWith<T> on BaseController<T> {
  /// Returns a callable class that can be used as follows: `instanceOfBaseController.copyWith(...)` or like so:`instanceOfBaseController.copyWith.fieldName(...)`.
  _$BaseControllerCWProxy<T> get copyWith =>
      _$BaseControllerCWProxyImpl<T>(this);
}
