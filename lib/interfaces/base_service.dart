import 'package:buzz_repo/interfaces/db_adapter.dart';
import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'base_service.g.dart';

@CopyWith()
class BaseService<T> {
  final DbAdapter<T> adapter;

  BaseService({required this.adapter});

  BaseService<T> offline(){
    final _adapter = adapter.offline();
    return copyWith(adapter: _adapter);
  }

  /*
  return the id of the created object
   */
  Future<Result<T>> add<T>(JsonObject dto, {final bool forceRemoteTrans = false}) async =>
      await adapter.add<T>(dto, forceRemoteTrans: forceRemoteTrans);

  Future<Result<T>> addById<T>(
          String id, JsonObject dto) async =>
      await adapter.addById<T>(dto);

  /*
  return the id of the created object
   */
  Future<Result<T>> get<T>(IDs ids) async => await adapter.get<T>(ids);

  Future<Result<T>> getOffline<T>(IDs ids) async {
    return await adapter.get<T>(ids);
  }

  Future<Result> deleteById(IDs ids) async => await adapter.deleteById(ids);


  Future<Result<T>> update<T>(JsonObject<T> dto) async =>
      await adapter.update<T>(dto);


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
    int limit = 10,
  }) async =>
      await adapter.getAll<T>(
        field: field,
        isEqualTo: isEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        isNull: isNull,
        limit: limit,
        // query: query,
        // startAfterDoc: startAfterDoc,
      );
}
