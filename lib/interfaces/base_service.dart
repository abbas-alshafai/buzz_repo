import 'package:buzz_repo/interfaces/json_object.dart';

import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';

import 'db_adapter.dart';

class BaseService<T> {
  DbAdapter<T> adapter;

  BaseService({required this.adapter});

  /// return the id of the created object
  Future<Result<T>> add<T>(JsonObject dto) async =>
      await adapter.add<T>(dto);

  Future<Result<T>> addById<T>(JsonObject dto) async => await adapter.addById(dto);

  /// return the id of the created object
  Future<Result<T?>> get<T>(IDs ids) async => await adapter.get<T>(ids);

  Future<Result<T?>> getOffline<T>(IDs ids) async {
    return await adapter.get<T>(ids);
  }

  Future<Result<T>> update<T>(JsonObject<T> dto) async =>
      await adapter.update<T>(dto);

  Future<Result> callFunction(
      {required final String functionName,
        required final Map<String, dynamic>? data,
        final int durationSeconds = 30}) {
    return adapter.callFunction(
        functionName: functionName,
        data: data,
        durationSeconds: durationSeconds);
  }

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
    // int limit = 10,
    // Query? query,
    // DocumentSnapshot? startAfterDoc,
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
        // query: query,
        // startAfterDoc: startAfterDoc,
      );
}