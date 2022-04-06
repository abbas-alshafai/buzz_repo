import 'dart:convert';

import 'package:buzz_repo/interfaces/to_json_object.dart';

import '../interfaces/db_typedef.dart';

class JsonUtils<T> {
  FromJsonFunc<T>? _fromJsonFunc;

  JsonUtils fromJson(FromJsonFunc<T> fromJsonFunc) {
    _fromJsonFunc = fromJsonFunc;
    return this;
  }

  String toEncodedJson(ToJsonObject obj) {
    return jsonEncode(obj.toJson());
  }

  dynamic appEncode(final dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
  }

  T fromString(String data) {
    assert(_fromJsonFunc != null);
    final json = jsonDecode(data);
    return _fromJsonFunc!(json);
  }
}
