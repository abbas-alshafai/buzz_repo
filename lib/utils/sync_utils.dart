enum SyncAction {
  add,
  update,
  delete,
}

extension ParseToString on SyncAction {
  String toShortString() {
    return toString().split('.').last;
  }
}