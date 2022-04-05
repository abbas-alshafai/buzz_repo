import 'package:buzz_utils/buzz_utils.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'ids.g.dart';

@CopyWith()
class IDs{

  final String? id;
  final dynamic localId;

  IDs({this.id, this.localId});
  factory IDs.id(String id) => IDs(id: id);
  factory IDs.localId(dynamic localId) => IDs(localId: localId);

  bool get hasIDs => StringUtils.instance.isNotBlank(id) || localId != null;

  @override
  String toString() => 'id: $id, localId: $localId';
}

