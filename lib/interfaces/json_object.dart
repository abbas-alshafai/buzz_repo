
import '../models/ids.dart';

abstract class JsonObject<T> {
  Map<String, Object?> toJson();

  IDs get ids;
  T copyWithIDs(IDs ids);

  bool isRepoOutOfSync = false;
}
