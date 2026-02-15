import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/repositories/folder_repository.dart';

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider).value;
  if (isar == null) {
    throw Exception('Isar database not initialized');
  }
  return FolderRepository(isar);
});
