import 'package:buzz_repo/buzz_repo.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'db_adapter_state.g.dart';

@CopyWith()
class DbAdapterState {
  final RemoteRepo? remoteRepo;
  final LocalDb? localDb;
  final bool bypassRemote;
  final bool bypassLocal;
  final bool isOnline;

  DbAdapterState({
    this.remoteRepo,
    this.localDb,
    this.bypassRemote = false,
    this.bypassLocal = true,
    this.isOnline = true,
  });
}
