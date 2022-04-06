import 'package:buzz_repo/utils/json_utils.dart';

abstract class ToJsonObject<T>{
  Map<String, Object?> toJson();
}