
import 'package:buzz_repo/interfaces/to_json_object.dart';

import '../models/ids.dart';

abstract class JsonObject<T> extends ToJsonObject{

  IDs get ids;
  T copyWithIDs(IDs ids);

  bool isRepoOutOfSync = false;
}
