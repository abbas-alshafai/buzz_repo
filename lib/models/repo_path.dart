import 'ids.dart';

class RepoPath{
  final String path;
  final IDs ids;

  RepoPath({required this.path, required this.ids});
}

class RemoteRepoPath{
  final String path;
  final String id;

  RemoteRepoPath({required this.path, required this.id});
}


class LocalRepoPath{
  final String path;
  final int id;

  LocalRepoPath({required this.path, required this.id});
}

