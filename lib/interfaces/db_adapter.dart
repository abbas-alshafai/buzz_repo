import 'package:buzz_logger/models/log.dart';
import 'package:buzz_logger/service/logger.dart';
import 'package:buzz_repo/constants/repo_constants.dart';
import 'package:buzz_repo/interfaces/db_typedef.dart';
import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/interfaces/local_repo.dart';
import 'package:buzz_repo/interfaces/remote_repo.dart';
import 'package:buzz_repo/models/db_adapter_state.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:buzz_repo/models/sync_dto.dart';
import 'package:buzz_repo/utils/sync_utils.dart';
import 'package:buzz_result/models/result.dart';
import 'package:buzz_utils/buzz_utils.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'db_adapter.g.dart';

// TODO - add maximum duration on remote trans
@CopyWith()
class DbAdapter<T> {
  final DbAdapterState? state;

  final FromJsonFunc<T> fromJson;
  final String tableName;
  final bool hasRemotePriority;

  DbAdapter({
    this.state,
    required this.fromJson,
    required this.tableName,
    this.hasRemotePriority = false,
  });

  bool get includeLocalTransactions =>
      !(state?.bypassLocal ?? false) && state?.localDb != null;

  bool get includeRemoteTransactions =>
      !(state?.bypassRemote ?? false) && state?.remoteRepo != null;

  bool get isLocalOnly =>
      includeLocalTransactions && !includeRemoteTransactions;

  bool get isRemoteOnly =>
      !includeLocalTransactions && includeRemoteTransactions;

  DbAdapter<T> offline() {
    final _state = (state as DbAdapterState).copyWith(bypassRemote: true);
    return copyWith(state: _state);
  }

  /*
  return the id of the created object
   */
  Future<Result<T>> add<T>(JsonObject dto,
      {final bool forceRemoteTrans = false}) async {
    assert(Logger.debug('$tableName: Attempting to add'));
    final localDb = await _localRepo();
    try {
      /*
      We start with the local so we get the localId, then we store it remotely
       */
      if (includeLocalTransactions) {
        Logger.i('$tableName: Attempting to locally add');
        try {
          final result = await localDb!.add<T>(dto);
          dto = dto.copyWithIDs(IDs.localId(result));
          assert(Logger.debug('successfully added locally'));
        } catch (e, st) {
          Logger.error(
            st,
            '$tableName: An error occurred while locally adding.\n${e.toString()}',
          );
          Result.error(msg: e.toString(), stacktrace: st);
        }
      }

      if (!forceRemoteTrans && !includeRemoteTransactions) {
        if (dto.ids.localId == null) {
          throw ArgumentError.value(dto.ids.localId, 'localId');
        }
        return Result.success(obj: dto as T?);
      }

      Logger.i('$tableName: Attempting to remotely add.');
      final remoteResult = await _remoteRepo!.add<T>(dto);

      if (remoteResult.hasFailedOrNull) {
        Logger.error(StackTrace.current,
            '$tableName: adding object to remote repo has failed.');
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
      if (includeLocalTransactions) {
        try {
          final result = await localDb!.add<T>(dto);
        } catch (e, st) {
          Logger.error(st,
              '$tableName: adding object to local repo has failed.\n${e.toString()}');
        }
      }

      assert(Logger.debug('successfully added remotely'));
      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb?.close();
    }
  }

  // TODO refactor and compare against add
  Future<Result<T>> addById<T>(JsonObject dto) async {
    final localDb = await _localRepo();
    try {
      if (includeLocalTransactions) {
        try {
          final result = await localDb!.add<T>(dto);
          dto = dto.copyWithIDs(IDs.localId(result));
        } catch (e, st) {
          Logger.error(st, e.toString());
        }
      }

      if (!includeRemoteTransactions) {
        return Result.success(obj: dto as T?);
      }

      final remoteResult = await _remoteRepo!.add<T>(dto);

      if (remoteResult.hasFailedOrNull) {
        dto.isRepoOutOfSync = true;
      }

      if (includeLocalTransactions) {
        await localDb!.add<T>(dto);
      }

      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb?.close();
    }
  }

  Future<Result<T>> get<T>(IDs ids) async {
    final localDb = await _localRepo();
    try {
      if (hasRemotePriority && includeRemoteTransactions) {
        final result = await _remoteRepo!.get<T>(ids);
        if (result.isSuccessfulObj) return result;
      }

      if (includeLocalTransactions && ids.localId != null) {
        final result = await localDb!.get<T>(ids);
        if (result.isSuccessfulObj) return result;
      }

      if (includeRemoteTransactions &&
          StringUtils.instance.isNotBlank(ids.id)) {
        final remoteResult = await _remoteRepo!.get<T>(ids);
        if (remoteResult.isSuccessfulObj) {
          await localDb!.add<T>(remoteResult.obj as JsonObject<T>);
        }
        return remoteResult;
      }

      return Result.error(
          log: Log(msg: 'No local or remote result for ids ${ids.toString()}'));
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      // localDb.close();
    }
  }

  Future<Result<T>> update<T>(JsonObject dto) async {
    final localDb = await _localRepo();
    try {
      assert(dto.ids.id != null || dto.ids.localId != null);

      if (dto.ids.id == null && dto.ids.localId == null) {
        return add(dto);
      }

      // if not added locally
      if (includeRemoteTransactions &&
          includeLocalTransactions &&
          dto.ids.localId == null) {
        try {
          final result = await localDb!.add<T>(dto);
          dto.copyWithIDs(dto.ids.copyWith(localId: result));
        } catch (e, st) {
          Logger.error(st, e.toString());
        }
      }

      if (includeRemoteTransactions) {
        if (dto.ids.id == null) {
          final Result<String> remoteResult = await _remoteRepo!.add<T>(dto);
          if (remoteResult.hasFailedOrNull) {
            dto.isRepoOutOfSync = true;
            _saveOutOfSync(ids: dto.ids, action: SyncAction.update, dto: dto);
          } else {
            dto.copyWithIDs(
                dto.ids.copyWith(id: (remoteResult.obj! as String)));
          }
        } else {
          final Result<T> remoteResult = await _remoteRepo!.update(dto);

          if (remoteResult.hasFailedOrNull) {
            dto.isRepoOutOfSync = true;
            _saveOutOfSync(ids: dto.ids, action: SyncAction.update, dto: dto);
          } else {
            dto.copyWithIDs(
              dto.ids.copyWith(id: (remoteResult.obj! as JsonObject).ids.id),
            );
          }
        }
      }

      if (includeLocalTransactions) {
        final result = await localDb!.update(dto);
        dto.copyWithIDs(
          dto.ids.copyWith(localId: (result.obj as JsonObject).ids.localId),
        );
      }

      // TODO - report (Result.error) if an error occurs remotely or locally?
      return Result.success(obj: dto as T?);
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb?.close();
    }
  }

  Future<Result> deleteById(final IDs ids) async {
    Logger.d('$tableName: Attempting to delete - ${ids.toString()}');
    final localDb = await _localRepo();
    try {
      Logger.d('$tableName: Attempting to locally delete - ${ids.toString()}');
      if (includeLocalTransactions) {
        await localDb!.delete(ids);
      }
    } catch (e, st) {
      // TODO put in re-sync queue
      Logger.error(st, e.toString());
    }

    try {
      if (includeRemoteTransactions) {
        Logger.d(
            '$tableName: Attempting to remotely delete - ${ids.toString()}');
        await _remoteRepo!.delete(ids);
        Logger.d('$tableName: Successfully deleted remote - ${ids.toString()}');
      }
      return Result.success();
    } catch (e, st) {
      await _saveOutOfSync(
        action: SyncAction.delete,
        ids: ids,
      );
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb?.close();
    }
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
    int limit = 10,
    // Query? query,
    // DocumentSnapshot? startAfterDoc,
  }) async {
    final localDb = await _localRepo();
    try {
      if (hasRemotePriority) {
        final result = await _remoteRepo!.getAll<T>(
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
          return Result.success(obj: result.obj!.whereType<T>().toList());
        }
      }

      if (includeLocalTransactions) {
        try {
          final result = await localDb!.getAll<T>();

          if (result.hasFailed) {
            Logger.error(
              StackTrace.current,
              '$tableName: A failure occurred when locally getting all objects',
            );
          } else if (result.isSuccessfulObj) {
            return Result.success(obj: result.obj!.whereType<T>().toList());
          }
        } catch (e, st) {
          Logger.error(st, e.toString());
        }
      }

      if (includeRemoteTransactions) {
        final result = await _remoteRepo!.getAll<T>(
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
          return Result.success(obj: result.obj!.whereType<T>().toList());
        } else {
          Logger.error(
            StackTrace.current,
            '$tableName: A failure occurred when remotely getting all objects',
          );
        }
      }

      return Result.error(
        log: Log(msg: 'An error occurred when querying a list'),
      );
    } catch (e, st) {
      return _getErrorLog(msg: e.toString(), stacktrace: st);
    } finally {
      localDb?.close();
    }
  }

  Future<Result> close() async {
    final localDb = await _localRepo();
    localDb?.close();

    return Result.success();
  }

  Result<T> _getErrorLog<T>({
    required final String msg,
    final StackTrace? stacktrace,
  }) {
    Logger.error(stacktrace ?? StackTrace.current, msg);
    return Result<T>.error(
      log: Log(
        stacktrace: stacktrace,
        logLevel: LogLevel.error,
        msg: _buildMessage(msg),
      ),
    );
  }

  String _buildMessage(final String msg) => '(path $tableName): $msg';

  Future<Result> _saveOutOfSync({
    required SyncAction action,
    required IDs ids,
    JsonObject? dto,
  }) async {
    assert(Logger.debug('buzz repo - about to save an of sync object'));
    if (!includeLocalTransactions) {
      assert(Logger.debug('buzz repo - local storage is not allowed.'));
      return Result.error();
    }

    final localDb = await _localRepo(table: SyncDto.tableName);
    final localSyncDb = await localDb?.ofTable(BuzzRepoConstants.syncTable);

    try {
      final result = await localSyncDb?.add<T>(
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

  Future<LocalDb?> _localRepo({final String? table}) async {
    final localDb = state?.localDb;
    if (localDb == null) {
      return localDb;
    }

    if (!localDb.isInitialized()) {
      await localDb.init();
    }
    return await localDb.ofTable(table ?? tableName);
  }

  RemoteRepo? get _remoteRepo {
    return state?.remoteRepo?.ofTable(tableName).fromJson(fromJson);
  }
}
