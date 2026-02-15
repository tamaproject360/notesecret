import 'package:isar/isar.dart';
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
  
  // Use Isar query filters for efficient database querying
  // instead of filtering all notes in memory
  return await isar.notes.filter()
      .tags((q) => q.idEqualTo(selectedTag.id))
      .deletedAtIsNull()
      .isLockedEqualTo(false)
      .sortByUpdatedAtDesc()
      .findAll();
}
