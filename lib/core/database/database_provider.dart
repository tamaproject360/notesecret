import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/core/database/models/folder.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(IsarDatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  
  // Open Isar instance
  final isar = await Isar.open(
    [NoteSchema, TagSchema, FolderSchema],
    directory: dir.path,
  );
  
  return isar;
}
