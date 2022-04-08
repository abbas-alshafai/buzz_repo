
import 'package:buzz_repo/interfaces/json_object.dart';
import 'package:buzz_repo/models/ids.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

import '../utils/sync_utils.dart';

part 'sync_dto.g.dart';

const String _id = 'id';
const String _localId = 'lid';
const String _table = 'table';
const String _action = 'act';

@CopyWith()
class SyncDto extends JsonObject<SyncDto> {
  final String? id;
  final int? localId;
  final String table;
  final SyncAction action;

  SyncDto({
    this.id,
    this.localId,
    required this.table,
    this.action = SyncAction.update,
  });

  @override
  IDs get ids => IDs(
    id: id,
    localId: localId,
  );

  @override
  SyncDto copyWithIDs(IDs? ids) => copyWith(
    id: ids?.id ?? id,
    localId: ids?.localId ?? localId,
  );

  @override
  Map<String, Object?> toJson() => {
    _id: id,
    _localId: localId,
    _table: table,
    _action: action.toShortString(),
  };


  factory SyncDto.fromJson(Map<String, dynamic> json) => SyncDto(
    id: json[_id],
    localId: json[_localId],
    table: json[_table],
    action: json[_action],
  );

}


