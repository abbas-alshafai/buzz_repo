
import 'package:buzz_result/models/result.dart';

import '../models/ids.dart';
import 'json_object.dart';

abstract class LocalDb<T> {
  LocalDb();
  Future init();
  bool isInitialized();
  Future close();
  Future<LocalDb> ofTable<T>(String table);
  Future<LocalDb> ofPath<T>(String path);
  Future<int?> add<T>(JsonObject object);
  Future<Result<T>> update<T>(JsonObject object);
  Future<Result<T>> get<T>(IDs ids);
  Future<Result<List<T>>> getAll<T>();
  Future<Result> delete(IDs ids);
}
