import 'package:buzz_repo/interfaces/json_object.dart';

import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';

import 'db_adapter.dart';

class BaseService<T> {
  DbAdapter<T> adapter;

  BaseService({required this.adapter});

  /*
  return the id of the created object
   */
  Future<Result<T>> add<T>(JsonObject dto) async =>
      await adapter.add<T>(dto);

  Future<Result<T>> addById<T>(
      String id, JsonObject dto) async =>
      await adapter.addById(id, dto);

  /*
  return the id of the created object
   */
  Future<Result<T?>> get<T>(IDs ids) async => await adapter.get<T>(ids);

  Future<Result<T?>> getOffline<T>(IDs ids) async {
    return await adapter.get<T>(ids);
  }
/*

  Stream<QuerySnapshot> stream(CollectionReference ref) {
    return adapter.stream(ref);
  }
*/

  // /*
  // return the id of the created object
  //  */
  // Future<Result<List<T>>> getDocs(
  //     {Query? query,
  //     dynamic field,
  //     dynamic isEqualTo,
  //     dynamic isLessThan,
  //     dynamic isLessThanOrEqualTo,
  //     dynamic isGreaterThan,
  //     dynamic isGreaterThanOrEqualTo,
  //     dynamic arrayContains,
  //     int limit = 10,
  //     DocumentSnapshot? startAfterDoc,
  //     List<dynamic>? arrayContainsAny,
  //     List<dynamic>? whereIn,
  //     bool? isNull}) async {
  //   try {
  //     Result<List<T>> result = await adapter.getDocs(
  //         query: query,
  //         field: field,
  //         whereIn: whereIn,
  //         arrayContains: arrayContains,
  //         isEqualTo: isEqualTo,
  //         isLessThan: isLessThan,
  //         isLessThanOrEqualTo: isLessThanOrEqualTo,
  //         arrayContainsAny: arrayContainsAny,
  //         isGreaterThan: isGreaterThan,
  //         isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
  //         isNull: isNull,
  //         limit: limit,
  //         startAfterDoc: startAfterDoc);
  //
  //     if (result.hasFailed) ;
  //
  //     return result;
  //   } catch (e, stacktrace) {
  //     return Result.error(
  //       msg: e.toString(),
  //       stacktrace: stacktrace,
  //     );
  //   }
  // }

  Future<Result<T>> update<T>(JsonObject<T> dto) async =>
      await adapter.update<T>(dto);

  //
  // Future<Result<String>> updateData(
  //     String id, Map<String, Object?>? data) async {
  //   try {
  //     assert(MapUtils.instance.isNotEmpty(data));
  //     assert(StringUtils.instance.isNotBlank(id));
  //
  //     Result<String> result = await adapter.updateData(id, data);
  //
  //     if (result.hasFailed) ;
  //
  //     return result;
  //   } catch (e, stacktrace) {
  //     return Result.failure(
  //       msg: e.toString(),
  //       stacktrace: stacktrace,
  //     );
  //   }
  // }
  //
  Future<Result> callFunction(
      {required final String functionName,
        required final Map<String, dynamic>? data,
        final int durationSeconds = 30}) {
    return adapter.callFunction(
        functionName: functionName,
        data: data,
        durationSeconds: durationSeconds);
  }
/*

  Future<Result<List<T?>>> getAllOffline<T>({
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

*/

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

// class RepoUtils {
//   RepoUtils._();
//   static final instance = RepoUtils._();
//
//   FirebaseFirestore getRef() {
//     return FirebaseFirestore.instance;
//   }
// }
