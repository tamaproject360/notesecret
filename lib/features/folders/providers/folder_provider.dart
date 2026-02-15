import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/models/folder.dart';
import 'package:notesecret/core/database/repositories/folder_repository.dart';

part 'folder_provider.g.dart';

@Riverpod(keepAlive: true)
Future<FolderRepository> folderRepository(FolderRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return FolderRepository(isar);
}

@riverpod
Stream<List<Folder>> allFolders(AllFoldersRef ref) async* {
  final repository = await ref.watch(folderRepositoryProvider.future);
  yield* repository.watchAllFolders();
}

@riverpod
Future<Folder?> folder(FolderRef ref, int id) async {
  final repository = await ref.watch(folderRepositoryProvider.future);
  return repository.getFolder(id);
}
