import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/core/database/repositories/note_repository.dart';

part 'note_provider.g.dart';

@Riverpod(keepAlive: true)
Future<NoteRepository> noteRepository(NoteRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return NoteRepository(isar);
}

@riverpod
Stream<List<Note>> allNotes(AllNotesRef ref) async* {
  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.watchAllNotes();
}

@riverpod
Stream<List<Note>> pinnedNotes(PinnedNotesRef ref) async* {
  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.watchPinnedNotes();
}

@riverpod
Stream<List<Note>> normalNotes(NormalNotesRef ref) async* {
  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.watchNormalNotes();
}

@riverpod
Stream<List<Note>> lockedNotes(LockedNotesRef ref) async* {
  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.watchLockedNotes();
}

@riverpod
Future<Note?> note(NoteRef ref, int id) async {
  final repository = await ref.watch(noteRepositoryProvider.future);
  return repository.getNote(id);
}

@riverpod
Stream<List<Note>> notesInFolder(NotesInFolderRef ref, int folderId) async* {
  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.watchNotesInFolder(folderId);
}
