import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';

import 'package:buzz_utils/buzz_utils.dart';

import 'base_service.dart';

class BaseController<T> {
  final BaseService<T> service;
  final bool isOfflineOnly;

  BaseController({
        required this.service,
        this.isOfflineOnly = true,
      });

  Future<Result<T>> get<T>(IDs ids) async =>
      await tryCatch<T>(() async => await service.get<T>(ids));

  Future<Result<List<T>>> getAll<T>({
    dynamic field,
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    bool? isNull,
    int limit = 500,
    // Query? query,
    // DocumentSnapshot? startAfterDoc,
  }) async {
    try {
      return await service.getAll<T>();
    } catch (e) {
      return Result.error(msg: e.toString());
    }
  }

  Future<Result<T?>> getOffline<T>(IDs ids) async =>
      await tryCatch<T>(() async => await service.getOffline<T>(ids));

  Future<Result<T>> add<T>(JsonObject dto) async {
    try {
      return await service.add<T>(dto);
    } catch (e) {
      return Result.error(msg: e.toString());
    }
  }

  Future<Result<T>> update<T>(JsonObject<T> dto) async =>
      await service.update<T>(dto);

  Future<Result<T>> addById<T>(String id, JsonObject<T> dto) async =>
      await service.addById<T>(id, dto);

  Future<Result<T>> write<T>(JsonObject<T> dto) async =>
      StringUtils.instance.isBlank(dto.ids.id)
          ? await add<T>(dto)
          : await update<T>(dto);

  Future<Result<E>> tryCatch<E>(Function f) async {
    try {
      return await f.call();
    } catch (e) {
      return Result.error();
    }
  }
}
