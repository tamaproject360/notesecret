import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/models/note.dart';

part 'tag_filter_provider.g.dart';

@riverpod
class SelectedTagFilter extends _$SelectedTagFilter {
  @override
  Tag? build() {
    return null;
  }

  void setTag(Tag? tag) {
    state = tag;
  }

  void clear() {
    state = null;
  }
}

@riverpod
Future<List<Note>> filteredNotesByTag(FilteredNotesByTagRef ref) async {
  final selectedTag = ref.watch(selectedTagFilterProvider);
  
  if (selectedTag == null) {
    return [];
  }

  final isar = await ref.watch(isarDatabaseProvider.future);
  
  // Query notes that have this tag
  final notes = await isar.notes
      .filter()
      .deletedAtIsNull()
      .isLockedEqualTo(false)
      .sortByUpdatedAtDesc()
      .findAll();
  
  // Filter by tag
  final filteredNotes = <Note>[];
  for (final note in notes) {
    await note.tags.load();
    if (note.tags.any((tag) => tag.id == selectedTag.id)) {
      filteredNotes.add(note);
    }
  }
  
  return filteredNotes;
}
