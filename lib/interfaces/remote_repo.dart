import 'package:buzz_result/models/result.dart';

import '../models/ids.dart';
import 'db_typedef.dart';
import 'json_object.dart';

abstract class RemoteRepo<T> {
  RemoteRepo();

  Future init();

  RemoteRepo ofTable(String table);

  RemoteRepo ofPath(Map<String, String> path);

  RemoteRepo fromJson(FromJsonFunc<T> fromJsonFunc);

  Future<Result<T>> get<T>(IDs id);

  Future<Result<String>> add<T>(JsonObject object);

  Future<Result<T>> addById<T>(JsonObject object);

  Future<Result<T>> update<T>(JsonObject dto);

  Future<Result<List<T>>> getAll<T>({
    final int? limit,
    final String? orderByField,
    final bool descending = false,
    final Object? field,
    final Map<String, String>? isEqualTo,
    final Object? isNotEqualTo,
    final Object? isLessThan,
    final Object? isLessThanOrEqualTo,
    final Object? isGreaterThan,
    final Object? isGreaterThanOrEqualTo,
    final Object? arrayContains,
    final List<Object?>? arrayContainsAny,
    final List<Object?>? whereIn,
    final List<Object?>? whereNotIn,
    final bool? isNull,
  });

  delete(IDs id);

  Future<Result<List<T>>> getInById<T>({required List<dynamic> list});

  Future<Result<List<T>>> getIn<T>(
      {required List<dynamic> list, required dynamic fieldName});

  Future<Result> callFunction({required final String functionName,
    required final Map<String, dynamic>? data,
    final int durationSeconds = 30});
}
