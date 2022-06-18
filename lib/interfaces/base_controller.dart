import 'package:buzz_logger/service/logger.dart';
import 'package:buzz_repo/interfaces/base_service.dart';
import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'base_controller.g.dart';

@CopyWith()
class BaseController<T> {
  final BaseService<T> service;

  BaseController({required this.service});


  BaseController<T> offline(){
    final _service = service.offline();
    return copyWith(service: _service);
  }

  Future<Result<T>> get<T>(IDs ids) async =>
      await tryCatch<T>(() async => await service.get<T>(ids));

  Future<Result<List<T>>> getAll<T>({
    final bool storeBusinessSpecific = true,
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
    int limit = 10,
  }) async {
    try {
      return await service.getAll<T>();
    } catch (e) {
      return Result.error(msg: e.toString());
    }
  }

  Future<Result> deleteById(IDs ids) async {
    try {
      return await service.deleteById(ids);
    } catch (e) {
      return Result.error(msg: e.toString());
    }
  }

  Future<Result<T>> getOffline<T>(IDs ids) async =>
      await tryCatch<T>(() async => await service.getOffline<T>(ids));

  Future<Result<T>> add<T>(JsonObject dto,
      {final forceRemoteTrans = false}) async {
    try {
      return await service.add<T>(dto, forceRemoteTrans: forceRemoteTrans);
    } catch (e, st) {
      Logger.error(st, e.toString());
      return Result.error(msg: e.toString());
    }
  }

  Future<Result<T>> update<T>(JsonObject<T> dto) async =>
      await service.update<T>(dto);

  Future<Result<T>> addById<T>(String id, JsonObject<T> dto) async =>
      await service.addById<T>(id, dto);


  Future<Result<T>> write<T>(JsonObject<T> dto) async =>
      dto.ids.hasIDs ? await update(dto) : await add<T>(dto);

  Future<Result<E>> tryCatch<E>(Function f) async {
    try {
      return await f.call();
    } catch (e, st) {
      return Result.error(msg: e.toString(), stacktrace: st);
    }
  }
}
