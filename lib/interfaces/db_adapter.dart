import 'package:buzz_logger/service/logger.dart';
import 'package:buzz_repo/interfaces/db_typedef.dart';
import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/interfaces/remote_repo.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_result/models/result.dart';
import 'package:buzz_utils/buzz_utils.dart';
import 'package:buzz_logger/models/log.dart';

import '../models/sync_dto.dart';
import '../utils/sync_utils.dart';
import 'local_repo.dart';


class DbAdapter<T> {
  final FromJsonFunc<T> fromJson;
  final bool hasRemotePriority;
  final bool isRemoteOnly;
  final String tableName;
  final bool includeRemoteTrans;
  final bool includeLocalTrans;
  final LocalDb localDb;

  DbAdapter(
      {
        required this.fromJson,
        required this.tableName,
        this.hasRemotePriority = false,
        this.isRemoteOnly = true,
        this.includeLocalTrans = false,
        this.includeRemoteTrans = true,
        required this.localDb,
      });

  /*
  return the id of the created object
   */
  Future<Result<T>> add<T>(JsonObject dto) async {
    Logger.d('$tableName: Attempting to add');
    LocalDb localDb = await _localRepo;
    try {
      /*
      We start with the local so we get the localId, then we store it remotely
       */
      if (includeLocalTrans) {
        Logger.i('$tableName: Attempting to locally add');
        try {
          final result = await localDb.add<T>(dto);
          dto = dto.copyWithIDs(IDs.localId(result));
        } catch (e, st) {
          Logger.error(
            st,
            '$tableName: An error occurred while locally adding.',
          );
          Result.error(msg: e.toString(), stacktrace: st);
        }
      }

      if (!includeRemoteTrans) {
        return dto.ids.localId == null
            ? Result.error()
            : Result.success(obj: dto as T?);
      }

      Logger.i('$tableName: Attempting to remotely add');
      final remoteResult = await _remoteRepo.add<T>(dto);

      if (remoteResult.hasFailedOrNull) {
        dto.isRepoOutOfSync = true;
        await _saveOutOfSync(
          dto: dto,
          action: SyncAction.add,
          ids: IDs.localId(dto.ids.localId),
        );
      } else {
        dto = dto.copyWithIDs(IDs.id(remoteResult.obj!));
      }

      /*
      We add locally to report two things:
        1- if the record is out of sync, when we couldn't add remotely
        2- to update local record with the remote id
       */
      if (includeLocalTrans) {
        final result = await localDb.add<T>(dto);
      }

      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  // TODO refactor and compare against add
  Future<Result<T>> addById<T>(JsonObject dto) async {
    LocalDb localDb = await _localRepo;
    try {
      if (includeLocalTrans) {
        try {
          final result = await localDb.add(dto);
          dto = dto.copyWithIDs(IDs.localId(result));
        } catch (e, st) {
          Logger.error(st, e.toString());
        }
      }

      if (!includeRemoteTrans) {
        return Result.success(obj: dto as T?);
      }

      final remoteResult = await _remoteRepo.addById(dto);

      if(remoteResult.hasFailedOrNull) {
        dto.isRepoOutOfSync = true;
      }

      if (includeLocalTrans) await localDb.add(dto);

      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result<T>> get<T>(IDs ids) async {
    LocalDb localDb = await _localRepo;
    try {
      if (hasRemotePriority) {
        final result = await _remoteRepo.get<T>(ids);
        if (result.isSuccessfulObj) return result;
      }

      if (includeLocalTrans && ids.localId != null) {
        final result = await localDb.get<T>(ids);
        if (result.isSuccessfulObj) return result;
      }

      if (includeRemoteTrans && StringUtils.instance.isNotBlank(ids.id)) {
        return await _remoteRepo.get<T>(ids);
      }

      return Result.error(
          log: Log(msg: 'No local or remote result for ids ${ids.toString()}'));
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      // localDb.close();
    }
  }

  Future<Result<List<T>>> getInById<T>({required List<dynamic> list}) async {
    LocalDb localDb = await _localRepo;
    try {
      return await _remoteRepo.getInById<T>(list: list);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result> getWhereIn<T>(
      {required List<T> list, required String fieldName}) async {
    LocalDb localDb = await _localRepo;
    try {
      return await _remoteRepo.getWhereIn(list: list, fieldName: fieldName);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result<List<T>>> getListsWhereIn(
      {required List<List<dynamic>> lists, required dynamic fieldName}) async {
    LocalDb localDb = await _localRepo;
    try {
      return await _remoteRepo.getListsWhereIn(
          lists: lists, fieldName: fieldName);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result<List<T>>> getIn(
      {required List<dynamic> list, required dynamic fieldName}) async {
    LocalDb localDb = await _localRepo;
    try {
      return await getIn(list: list, fieldName: fieldName);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result<T>> update<T>(JsonObject dto) async {
    LocalDb localDb = await _localRepo;
    try {
      if (includeRemoteTrans) {
        final remoteResult = await _remoteRepo.update<T>(dto);

        if (remoteResult.hasFailedOrNull) {
          dto.isRepoOutOfSync = true;
          _saveOutOfSync(ids: dto.ids, action: SyncAction.update, dto: dto);
        }
      }

      if (includeLocalTrans) {
        final result = await localDb.update<T>(dto);
        if (result.hasFailed) {
          ; // TODO
          return result;
        }
      }

      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result> deleteById(final IDs ids) async {
    Logger.d('$tableName: Attempting to delete - ${ids.toString()}');
    LocalDb localDb = await _localRepo;
    try {
      Logger.d('$tableName: Attempting to locally delete - ${ids.toString()}');
      await localDb.delete(ids);
    } catch (e, st) {
      // TODO put in re-sync queue
      Logger.error(st, e.toString());
    }
    try {
      Logger.d('$tableName: Attempting to remotely delete - ${ids.toString()}');
      await _remoteRepo.delete(ids);
      Logger.d('$tableName: Successfully deleted remote - ${ids.toString()}');
      return Result.success();
    } catch (e, st) {
      await _saveOutOfSync(
        action: SyncAction.delete,
        ids: ids,
      );
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Future<Result> callFunction(
      {required final String functionName,
        required final Map<String, dynamic>? data,
        final int durationSeconds = 30}) async =>
      _remoteRepo.callFunction(functionName: functionName, data: data);

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
    // await _read(localDbProvider).ref(repo.tableName).getAll<T?>();

    LocalDb localDb = await _localRepo;
    try {
      if (hasRemotePriority) {
        final result = await _remoteRepo.getAll<T>(
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
        );

        if (result.isSuccessfulObj) {
          return Result.success(obj: result.obj!);
          // return Result.success(obj: Utils.instance.getList(result.obj!));
        }
      }

      if (includeLocalTrans) {
        try {
          final result = await localDb.getAll<T>(
            // field: field,
            // isEqualTo: isEqualTo,
            // isLessThan: isLessThan,
            // isLessThanOrEqualTo: isLessThanOrEqualTo,
            // isGreaterThan: isGreaterThan,
            // isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            // arrayContains: arrayContains,
            // arrayContainsAny: arrayContainsAny,
            // whereIn: whereIn,
            // isNull: isNull,
            // limit: limit,
          );

          if (result.isSuccessfulObj) {
            return Result.success(obj: result.obj!);
          }
        } catch (e, st) {
          Logger.error(st, e.toString());
        }
      }

      if (includeRemoteTrans) {
        final result = await _remoteRepo.getAll<T>(
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

        if (result.isSuccessfulObj) {
          return Result.success(obj: result.obj!);
        }
      }

      return Result.error(
        log: Log(msg: 'An error occurred when querying a list'),
      );
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb.close();
    }
  }

  Result<T> _getErrorLog<T>({
    required final String msg,
    final StackTrace? stacktrace,
  }) =>
      Result<T>.error(
        log: Log(
          stacktrace: stacktrace,
          logLevel: LogLevel.ERROR,
          table: tableName,
          msg: _buildMessage(msg),
        ),
      );

  String _buildMessage(final String msg) => '(path $tableName): $msg';

  Future<Result> _saveOutOfSync({
    required SyncAction action,
    required IDs ids,
    JsonObject? dto,
  }) async {
    try {
      final result = await localDb.ofTable('sync')..add(
        SyncDto(
          id: ids.id,
          localId: ids.localId,
          table: tableName,
          action: action,
        ),
      );

      return Result.success(obj: result);
    } catch (e, st) {
      Logger.error(
        st,
        'An error occurred while saving out-of-sync record.',
      );
      return Result.error(msg: 'An error while saving out of sync record');
    }
  }

  Future<LocalDb> get _localRepo async => localDb.ofTable(tableName);

  RemoteRepo get _remoteRepo => _remoteRepo
      .ofTable(tableName)
      .fromJson(fromJson);
}