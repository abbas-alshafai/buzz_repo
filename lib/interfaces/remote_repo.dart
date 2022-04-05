import 'package:buzz_result/models/result.dart';

import '../models/ids.dart';
import 'db_typedef.dart';
import 'json_object.dart';

abstract class RemoteRepo<T> {
  RemoteRepo();
  Future init();
  RemoteRepo ofTable(String table, {bool? hasBusinessStoreSwitcher});
  RemoteRepo fromJson(FromJsonFunc<T> fromJsonFunc);
  Future<Result<T>> get<T>(IDs id);
  Future<Result<String>> add<T>(JsonObject object);
  Future<Result<T>> addById<T>(JsonObject object);
  Future<Result<T>> update<T>(JsonObject dto);

  Future<Result<List<T>>> getAll<T>({
    int? limit,
    String? orderByField,
    bool descending = false,
    Object? field,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  });
  delete(IDs id);


  Future<Result> getWhereIn<T>(
      {required List<T> list, required String fieldName});

  Future<Result<List<T>>> getInById<T>({required List<dynamic> list});
  Future<Result<List<T>>> getListsWhereIn<T>(
      {required List<List<dynamic>> lists,
        required dynamic fieldName});

  Future<Result<List<T>>> getIn<T>(
      {required List<dynamic> list, required dynamic fieldName});

  Future<Result> callFunction(
      {required final String functionName,
        required final Map<String, dynamic>? data,
        final int durationSeconds = 30});
}
